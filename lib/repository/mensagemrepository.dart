import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'mensagem.dart';

class mensagem_repository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> enviarMensagem(String message, String receiverId) async {
    if (message == '') {
      return;
    }
    final FirebaseAuth auth = FirebaseAuth.instance;

    String senderId = auth.currentUser!.uid;
    Timestamp timestamp = Timestamp.now();

    Mensagem mensagem = Mensagem(
      message: message,
      senderId: senderId,
      receiverId: receiverId,
      timestamp: timestamp,
    );

    await FirebaseFirestore.instance
        .collection('mensagens')
        .doc()
        .set(mensagem.toMap());
  }

  Stream<List<Mensagem>> obterMensagensStream(String idDestinatario) async* {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String senderId = auth.currentUser!.uid;

    Stream<List<Mensagem>> listaMensagensStream() async* {
      Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshotEnviadas =
          FirebaseFirestore.instance
              .collection('mensagens')
              .where('senderId', isEqualTo: senderId)
              .where('receiverId', isEqualTo: idDestinatario)
              .orderBy('timestamp', descending: false)
              .snapshots();

      Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshotRecebidas =
          FirebaseFirestore.instance
              .collection('mensagens')
              .where('receiverId', isEqualTo: senderId)
              .where('senderId', isEqualTo: idDestinatario)
              .orderBy('timestamp', descending: false)
              .snapshots();

      await for (QuerySnapshot<Map<String, dynamic>> snapshot
          in querySnapshotEnviadas.mergeWith([querySnapshotRecebidas])) {
        List<Mensagem> mensagens = [];
        snapshot.docs.forEach((document) {
          Mensagem mensagem = Mensagem(
            message: document['message'],
            senderId: document['senderId'],
            receiverId: document['receiverId'],
            timestamp: document['timestamp'],
          );
          if (!mensagens.contains(mensagem)) {
            mensagens.add(mensagem);
          }
        });

        // Ordena as mensagens pelo timestamp
        mensagens.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        yield mensagens;
      }
    }

    yield* listaMensagensStream();
  }
}
