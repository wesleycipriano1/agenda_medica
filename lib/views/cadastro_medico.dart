import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/repository/medico.dart';
import 'package:flutter_application_1/repository/medico_repository.dart';

class CadastroMedico extends StatefulWidget {
  @override
  _CadastroMedicoState createState() => _CadastroMedicoState();
}

class _CadastroMedicoState extends State<CadastroMedico> {
  final _formKey = GlobalKey<FormState>();
  late String _nome = "";
  late String _crm = "";
  late String _especialidade = "";
  MedicoRepository medicorepository = MedicoRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Médico'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe o nome do médico';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nome = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'CRM'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe o CRM do médico';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _crm = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Especialidade'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe a especialidade do médico';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _especialidade = value!;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Medico novoMedico = Medico(
                        nome: _nome, crm: _crm, especialidade: _especialidade);
                    medicorepository.salvarMedico(novoMedico, context);
                  },
                  child: Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*Future<void> salvarMedico(Medico medico) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference medicos = firestore.collection('medicos');
    await medicos.add(medico.toMap());
    print('Médico salvo com sucesso!');
  } catch (e) {
    print('Erro ao salvar médico: $e');
  }
}void _salvarMedico() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Medico novoMedico =
          Medico(nome: _nome, crm: _crm, especialidade: _especialidade);
      salvarMedico(novoMedico);
      Navigator.pop(context);
    }
  }*/
