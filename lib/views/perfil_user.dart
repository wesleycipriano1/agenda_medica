import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/usuario.dart';
import 'package:flutter_application_1/repository/usuario_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({Key? key}) : super(key: key);

  @override
  _PerfilUsuarioState createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  File? _fotoPerfil;
  String _caminhoDaFotoNoStorage = "";

  final ImagePicker _picker = ImagePicker();
  final UsuarioRepository _usuarioRepository = UsuarioRepository();

  @override
  void initState() {
    super.initState();
    _atualizar_campos();
  }

  Future<void> _atualizar_campos() async {
    try {
      print('Obtendo usuário logado...');
      Usuario usuario = await _usuarioRepository.getUsuarioLogado();

      setState(() {
        _nomeController.text = usuario.nome;
        _enderecoController.text = usuario.endereco ?? '';
        _telefoneController.text = usuario.telefone ?? '';
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

  Future<void> _selecionarFoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _fotoPerfil = File(pickedFile.path);
        print(_fotoPerfil);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de usuário'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _selecionarFoto,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: _fotoPerfil != null
                        ? Image.file(_fotoPerfil!).image
                        : null,
                    child: _fotoPerfil == null ? Icon(Icons.person) : null,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(
                  labelText: 'Endereço',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  atualizarUsuario();
                },
                child: const Text('Atualizar cadastro'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void atualizarUsuario() async {
    try {
      // exibe a animação enquanto os dados estão sendo salvos
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Salvando dados...'),
          ],
        ),
        duration: Duration(minutes: 10), // define a duração máxima do SnackBar
      ));

      // atualiza os dados do usuário no Firebase Auth
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(_nomeController.text);
      }

      // atualiza os dados do usuário no Firestore
      final DocumentReference<Map<String, dynamic>> documentReference =
          FirebaseFirestore.instance.collection('usuarios').doc(user!.uid);
      final Map<String, dynamic> data = {
        'nome': _nomeController.text,
        'endereco': _enderecoController.text,
        'telefone': _telefoneController.text,
      };
      await documentReference.update(data);

      // atualiza a foto do usuário no Firebase Storage
      if (_fotoPerfil != null) {
        final Reference reference =
            FirebaseStorage.instance.ref().child('usuarios').child(user.uid);
        await reference.putFile(_fotoPerfil!);
        final String downloadUrl = await reference.getDownloadURL();
        await user.updatePhotoURL(downloadUrl);
        await documentReference.update(
            {'fotoUrl': downloadUrl}); // adiciona a URL da foto no Firestore
      }

      // exibe uma mensagem de sucesso
      messenger.removeCurrentSnackBar();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Dados atualizados com sucesso!'),
        ),
      );
    } catch (e) {
      print(e);
      // exibe uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar os dados: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

/*class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({Key? key}) : super(key: key);

  @override
  _PerfilUsuarioState createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Aqui você pode buscar os dados do usuário no Firebase e preencher os campos
    // com os dados salvos
    _nomeController.text = 'João Silva';
    _enderecoController.text = 'Rua X, 123 - Bairro Y - Cidade Z';
    _telefoneController.text = '(11) 99999-9999';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?u=example.com'),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(
                  labelText: 'Endereço',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Aqui você pode atualizar os dados do usuário no Firebase
                },
                child: const Text('Atualizar cadastro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

