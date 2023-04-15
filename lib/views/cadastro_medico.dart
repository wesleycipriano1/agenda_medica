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
  TextEditingController _nome = TextEditingController();
  TextEditingController _crm = TextEditingController();
  TextEditingController _especialidade = TextEditingController();
  TextEditingController _senhacontole = TextEditingController();
  TextEditingController _emailcontole = TextEditingController();
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
                  controller: _emailcontole,
                  decoration: InputDecoration(labelText: 'email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe o email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  controller: _senhacontole,
                  decoration: InputDecoration(labelText: 'senha'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe a senha';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nome,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe o nome do médico';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _crm,
                  decoration: InputDecoration(labelText: 'CRM'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe o CRM do médico';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _especialidade,
                  decoration: InputDecoration(labelText: 'Especialidade'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe a especialidade do médico';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Medico novoMedico = Medico(
                        nome: _nome.text,
                        crm: _crm.text,
                        especialidade: _especialidade.text,
                        email: _emailcontole.text,
                        senha: _senhacontole.text);
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
