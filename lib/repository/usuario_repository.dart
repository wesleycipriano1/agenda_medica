import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/repository/usuario.dart';

class UsuarioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usuariosCollection =
      FirebaseFirestore.instance.collection('usuarios');

  Future<List<Usuario>> buscarUsuarios() async {
    QuerySnapshot querySnapshot = await _usuariosCollection.get();
    List<Usuario> usuarios = [];

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String id = doc.id;
      String senha = data['senha'] ?? '';
      String endereco = data['endereco'] ?? '';
      String telefone = data['telefone'] ?? '';
      String foto = data['fotoUrl'] ?? '';

      Usuario usuario = Usuario(
        id: id,
        nome: data['nome'],
        email: data['email'],
        senha: senha,
        endereco: endereco,
        telefone: telefone,
        foto: foto,
      );
      usuarios.add(usuario);
    }

    return usuarios;
  }

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

  Future<Map<String, dynamic>?> buscarUsuarioPorId(String id) async {
    final doc = await _firestore.collection('usuarios').doc(id).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }
}
