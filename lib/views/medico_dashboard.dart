import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chegar_page.dart';
import 'package:flutter_application_1/views/agendamento.dart';
import 'package:flutter_application_1/views/cadastro_medico.dart';
import 'package:flutter_application_1/views/cadastro_page.dart';
import 'package:flutter_application_1/views/chat_medicos.dart';
import 'package:flutter_application_1/views/chat_pacientes.dart';
import 'package:flutter_application_1/views/historico_conulta.dart';
import 'package:flutter_application_1/views/inicio.dart';
import 'package:flutter_application_1/views/perfil_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/usuario.dart';
import 'package:flutter_application_1/repository/usuario_repository.dart';
import 'package:flutter_application_1/views/senha_tela.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class Dashboard_medico extends StatefulWidget {
  @override
  _Dashboard_medicoState createState() => _Dashboard_medicoState();
}

class _Dashboard_medicoState extends State<Dashboard_medico> {
  final _firebaseauth = FirebaseAuth.instance;
  FirebaseFirestore _bd = FirebaseFirestore.instance;
  final UsuarioRepository _usuarioRepository = UsuarioRepository();
  String usuarioID = "";
  String _nome = "";
  String _email = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color.fromARGB(255, 91, 125, 218)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Painel de controle'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 100,
              child: Card(
                color: Color.fromARGB(255, 110, 179, 235),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'seja bem vindo ' + _nome,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'aqui você controla todos os seu passos dentro de nossa aplicação,busque historico de consultas,marque exames e consultas e muito mais.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => chat_pacientes()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat),
                          SizedBox(height: 16),
                          Text('Falar com paciente '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _nome,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                accountEmail: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _email,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                decoration: BoxDecoration(),
              ),
              Padding(padding: EdgeInsets.all(10)),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("perfil"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.vpn_key),
                title: Text("gerenciar senha"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.settings_outlined),
                title: Text("configurações"),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("informações"),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("sair"),
                onTap: () {
                  sair();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  sair() async {
    await _firebaseauth.signOut().then((User) => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => inicio_page())));
  }
}
