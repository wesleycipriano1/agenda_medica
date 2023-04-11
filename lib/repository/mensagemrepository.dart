import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'mensagem.dart';

Future<void> enviarMensagem(String message, String receiverId) async {
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
      .doc() // cria um novo ID para a mensagem
      .set(mensagem.toMap());
}

Future<List<Mensagem>> obterMensagens(String receiverId) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String senderId = auth.currentUser!.uid;

  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
      .instance
      .collection('mensagens')
      .where('senderId', whereIn: [senderId, receiverId])
      .where('receiverId', whereIn: [senderId, receiverId])
      .orderBy('timestamp', descending: true)
      .get();

  List<Mensagem> mensagens = querySnapshot.docs
      .map((document) => Mensagem(
            message: document['message'],
            senderId: document['senderId'],
            receiverId: document['receiverId'],
            timestamp: document['timestamp'],
          ))
      .toList();

  return mensagens;
}
