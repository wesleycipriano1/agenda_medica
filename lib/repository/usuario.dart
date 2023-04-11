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

/*class Usuario {
  String id;
  final String nome;
  final String email;
  final String senha;

  Usuario(
      {this.id = "",
      required this.nome,
      required this.email,
      required this.senha});

  Map<String, dynamic> toJson() =>
      {'id': id, 'nome': nome, 'email': email, 'senha': senha};
}*/
