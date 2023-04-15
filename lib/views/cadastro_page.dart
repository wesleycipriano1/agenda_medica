import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/usuario.dart';
import 'package:flutter_application_1/views/loguin.dart';
import 'package:flutter_application_1/repository/usuario_repository.dart';

class cadastro_page extends StatefulWidget {
  const cadastro_page({super.key});

  @override
  State<cadastro_page> createState() => _cadastro_pageState();
}

class _cadastro_pageState extends State<cadastro_page> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaContoller = TextEditingController();
  final _numeroContoller = TextEditingController();

  final _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: InputDecoration(
              label: Text("nome completo"),
            ),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              label: Text("e-mail"),
            ),
          ),
          TextFormField(
            controller: _senhaContoller,
            decoration: InputDecoration(
              label: Text("senha"),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                cadastar();
              },
              child: const Text("Cadastrar ")),
        ],
      ),
    );
  }

  Future<void> criarUsuario() async {
    try {
      // Cria o usuário no Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaContoller.text,
      );

      // Adiciona o usuário no Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set({
        'nome': _nomeController.text,
        'email': _emailController.text,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('A senha é muito fraca');
      } else if (e.code == 'email-already-in-use') {
        print('O e-mail já está sendo usado por outra conta');
      }
    } catch (e) {
      print('Erro ao criar usuário: $e');
    }
  }

  cadastar() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaContoller.text,
      );
      await userCredential.user!
          .updateProfile(displayName: _nomeController.text);
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set({
        'nome': _nomeController.text,
        'email': _emailController.text,
      });
      if (userCredential != null) {
        userCredential.user!.updateDisplayName(_nomeController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("cadastro com sucesso,retornando a tela de login"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 10),
          ),
        );
        Timer(Duration(seconds: 5), () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => login()),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("senha fraca"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("e-mail ja utilizado"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 10),
          ),
        );
      }
    }
  }
}
