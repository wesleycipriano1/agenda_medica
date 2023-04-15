import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/falar_medico.dart';

import '../repository/medico.dart';
import '../repository/medico_repository.dart';

class chat_medicos extends StatefulWidget {
  @override
  _chat_medicosState createState() => _chat_medicosState();
}

class _chat_medicosState extends State<chat_medicos> {
  final medicoRepository = MedicoRepository();
  bool listacaregada = false;
  List<Medico> listaMedicos = [];

  @override
  void initState() {
    super.initState();
    _carregarMedicos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('falar com o medico'),
      ),
      body: listacaregada
          ? ListView.builder(
              itemCount: listaMedicos.length,
              itemBuilder: (BuildContext context, int index) {
                Medico medico = listaMedicos[index];
                return Card(
                  child: ListTile(
                    title: Text(medico.nome),
                    subtitle: Text(medico.especialidade),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  falar_medico(id_recebedor: medico.id)));
                      print(medico.id);
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

  void _carregarMedicos() async {
    List<Medico> _listaMedicos = await medicoRepository.getMedicos();
    print(medicoRepository.getMedicos());
    setState(() {
      listaMedicos = _listaMedicos;
      listacaregada = true;
    });
  }
}
