import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Mensagem {
  String message;
  String senderId;
  String receiverId;
  Timestamp timestamp;

  Mensagem(
      {required this.message,
      required this.senderId,
      required this.receiverId,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp,
    };
  }

  factory Mensagem.fromJson(Map<String, dynamic> json) {
    return Mensagem(
      message: json['message'],
      receiverId: json['receiverId'],
      senderId: json['senderId'],
      timestamp: json['timestamp'],
    );
  }
}
