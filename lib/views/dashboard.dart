import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chegar_page.dart';
import 'package:flutter_application_1/views/agendamento.dart';
import 'package:flutter_application_1/views/cadastro_medico.dart';
import 'package:flutter_application_1/views/cadastro_page.dart';
import 'package:flutter_application_1/views/historico_conulta.dart';
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

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _firebaseauth = FirebaseAuth.instance;
  FirebaseFirestore _bd = FirebaseFirestore.instance;
  final UsuarioRepository _usuarioRepository = UsuarioRepository();
  String usuarioID = "";
  String _nome = "";
  String _email = "";
  String _caminhoDaFotoNoStorage = "";
  File? _fotoPerfil;

  @override
  void initState() {
    _foto_user();

    super.initState();
  }

  Future<void> _foto_user() async {
    try {
      print('Obtendo usuário logado...');
      Usuario usuario = await _usuarioRepository.getUsuarioLogado();

      setState(() {
        _nome = usuario.nome;
        _email = usuario.email;
        _caminhoDaFotoNoStorage = usuario.foto ?? '';
        carregarFotoPerfil();
      });
    } catch (e) {
      print('Erro ao obter usuário logado: $e');
    }
  }

  Future<void> carregarFotoPerfil() async {
    File? foto = await buscarFoto(_caminhoDaFotoNoStorage);
    print("este é o caminho" + _caminhoDaFotoNoStorage);

    if (foto != null) {
      setState(() {
        _fotoPerfil = foto;
      });
    }
  }

  Future<File?> buscarFoto(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var bytes = response.bodyBytes;
        String nomeArquivo = url.split('/').last;
        File imagemTemporaria =
            await File('${(await getTemporaryDirectory()).path}/$nomeArquivo')
                .create();
        await imagemTemporaria.writeAsBytes(bytes);
        return imagemTemporaria;
      } else {
        print("Erro ao buscar foto: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Erro ao buscar foto 2: $e" + url);
      return null;
    }
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
                      leading: CircleAvatar(
                        radius: 40,
                        backgroundImage: _fotoPerfil != null
                            ? Image.file(_fotoPerfil!).image
                            : null,
                        child: _fotoPerfil == null ? Icon(Icons.person) : null,
                      ),
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
                                builder: (context) => CadastroMedico()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add),
                          SizedBox(height: 16),
                          Text('Cadastrar Médico'),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AgendamentoConsulta()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/cadastro.png',
                            height: 50.0,
                          ),
                          SizedBox(height: 16),
                          Text('Marcar Consulta'),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        //falta fazer o marcar exames
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.medical_services),
                          SizedBox(height: 16),
                          Text('Marcar Exames'),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoricoConsultas()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history),
                          SizedBox(height: 16),
                          Text('Histórico de Consultas'),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AgendamentoConsulta()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat),
                          SizedBox(height: 16),
                          Text('Falar com o Médico'),
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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _fotoPerfil != null
                        ? Image.file(_fotoPerfil!).image
                        : AssetImage("assets/user.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("perfil"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PerfilUsuario()));
                },
              ),
              ListTile(
                leading: Icon(Icons.vpn_key),
                title: Text("gerenciar senha"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => senha_tela()));
                },
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
        context, MaterialPageRoute(builder: (context) => chegar_page())));
  }
}
