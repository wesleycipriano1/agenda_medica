import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'mensagem.dart';

class mensagem_repository {
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

  /*Future<List<Mensagem>> _obterMensagens(String receiverId) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String senderId = auth.currentUser!.uid;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('mensagens')
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .orderBy('timestamp', descending: false)
        .get();

    List<Mensagem> mensagens = [];

    querySnapshot.docs.forEach((document) {
      Mensagem mensagem = Mensagem(
        message: document['message'],
        senderId: document['senderId'],
        receiverId: document['receiverId'],
        timestamp: document['timestamp'],
      );
      mensagens.add(mensagem);
    });

    return mensagens;
  }*/

  /*Future<List<Mensagem>> obterMensagens(String idrecebedor) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String senderId = auth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> querySnapshotEnviadas =
        await FirebaseFirestore.instance
            .collection('mensagens')
            .where('senderId', isEqualTo: senderId)
            .orderBy('timestamp', descending: false)
            .get();

    QuerySnapshot<Map<String, dynamic>> querySnapshotRecebidas =
        await FirebaseFirestore.instance
            .collection('mensagens')
            .where('receiverId', isEqualTo: senderId)
            .orderBy('timestamp', descending: false)
            .get();

    List<Mensagem> mensagens = [];

    querySnapshotEnviadas.docs.forEach((document) {
      Mensagem mensagem = Mensagem(
        message: document['message'],
        senderId: document['senderId'],
        receiverId: document['receiverId'],
        timestamp: document['timestamp'],
      );
      mensagens.add(mensagem);
    });

    querySnapshotRecebidas.docs.forEach((document) {
      Mensagem mensagem = Mensagem(
        message: document['message'],
        senderId: document['senderId'],
        receiverId: document['receiverId'],
        timestamp: document['timestamp'],
      );
      mensagens.add(mensagem);
    });

    // Ordena as mensagens pelo timestamp
    mensagens.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return mensagens;
  }*/

  Future<List<Mensagem>> obterMensagens(String idDestinatario) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String senderId = auth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> querySnapshotEnviadas =
        await FirebaseFirestore.instance
            .collection('mensagens')
            .where('senderId', isEqualTo: senderId)
            .where('receiverId', isEqualTo: idDestinatario)
            .orderBy('timestamp', descending: false)
            .get();

    QuerySnapshot<Map<String, dynamic>> querySnapshotRecebidas =
        await FirebaseFirestore.instance
            .collection('mensagens')
            .where('receiverId', isEqualTo: senderId)
            .where('senderId', isEqualTo: idDestinatario)
            .orderBy('timestamp', descending: false)
            .get();

    List<Mensagem> mensagens = [];

    querySnapshotEnviadas.docs.forEach((document) {
      Mensagem mensagem = Mensagem(
        message: document['message'],
        senderId: document['senderId'],
        receiverId: document['receiverId'],
        timestamp: document['timestamp'],
      );
      mensagens.add(mensagem);
    });

    querySnapshotRecebidas.docs.forEach((document) {
      Mensagem mensagem = Mensagem(
        message: document['message'],
        senderId: document['senderId'],
        receiverId: document['receiverId'],
        timestamp: document['timestamp'],
      );
      mensagens.add(mensagem);
    });

    // Ordena as mensagens pelo timestamp
    mensagens.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return mensagens;
  }
}
