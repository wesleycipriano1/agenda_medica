import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/falar_medico.dart';

import '../repository/usuario.dart';
import '../repository/usuario_repository.dart';

class chat_pacientes extends StatefulWidget {
  @override
  _chat_pacientesState createState() => _chat_pacientesState();
}

class _chat_pacientesState extends State<chat_pacientes> {
  final _usarioRepository = UsuarioRepository();
  bool listacaregada = false;
  List<Usuario> listaUsuarios = [];

  @override
  void initState() {
    super.initState();
    _carregarusuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('falar com o medico'),
      ),
      body: listacaregada
          ? ListView.builder(
              itemCount: listaUsuarios.length,
              itemBuilder: (BuildContext context, int index) {
                Usuario usuario = listaUsuarios[index];
                return Card(
                  child: ListTile(
                    title: Text(usuario.nome),
                    subtitle: Text(usuario.email),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      if (usuario.id != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    falar_medico(id_recebedor: usuario.id)));
                      } else {
                        print('não tem id');
                      }
                    },
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _carregarusuarios() async {
    List<Usuario> _listausurios = await _usarioRepository.buscarUsuarios();

    setState(() {
      listaUsuarios = _listausurios;
      listacaregada = true;
    });
  }
}
