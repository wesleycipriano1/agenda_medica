import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String id;
  String nome;
  String email;
  String senha;
  String? endereco;
  String? telefone;
  String? foto;

  Usuario({
    this.id = '',
    required this.nome,
    required this.email,
    required this.senha,
    this.endereco,
    this.telefone,
    this.foto,
  });
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      endereco: map['endereco'],
      telefone: map['telefone'],
      foto: map['foto'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'senha': senha,
        'telefone': telefone,
        'endereco': endereco,
        'fotoUrl': foto,
      };
}
