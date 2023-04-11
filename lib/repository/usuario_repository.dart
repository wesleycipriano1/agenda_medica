import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/repository/usuario.dart';

class UsuarioRepository {
  Future<Usuario> getUsuarioLogado() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();
      Map<String, dynamic> dados = document.data() as Map<String, dynamic>;

      String senha = dados['senha'] ?? '';
      String endereco = dados['endereco'] ?? '';
      String telefone = dados['telefone'] ?? '';
      String foto = dados['fotoUrl'] ?? '';

      return Usuario(
          nome: dados['nome'],
          email: dados['email'],
          senha: senha,
          endereco: endereco,
          telefone: telefone,
          foto: foto);
    } else {
      throw Exception('Usuário não está logado');
    }
  }

  Future<void> atualizarUsuario(String nome) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .update({
        'nome': nome,
      });
    } else {
      throw Exception('Usuário não está logado');
    }
  }
}
