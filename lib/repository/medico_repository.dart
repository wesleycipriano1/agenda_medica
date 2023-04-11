import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/medico.dart';

class MedicoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Medico>> getMedicos() async {
    QuerySnapshot querySnapshot = await _firestore.collection('medicos').get();

    List<Medico> medicos = [];

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      medicos.add(Medico(
          nome: data['nome'],
          crm: data['crm'],
          especialidade: data['especialidade']));
    }

    return medicos;
  }

  Future<void> salvarMedico(Medico medico, BuildContext context) async {
    try {
      if (medico.nome == "" || medico.crm == "" || medico.especialidade == "") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor, preencha todos os campos'),
          ),
        );
        return;
      }
      //FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference medicos = _firestore.collection('medicos');

      QuerySnapshot querySnapshot = await medicos
          .where('crm', isEqualTo: medico.crm)
          .where('nome', isEqualTo: medico.nome)
          .where('especialidade', isEqualTo: medico.especialidade)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await medicos.add(medico.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Médico salvo com sucesso!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Médico já existe no banco de dados!'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar médico: $e'),
        ),
      );
    }
  }

  /*Future<void> salvarMedico(Medico medico, BuildContext context) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference medicos = firestore.collection('medicos');
      await medicos.add(medico.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Médico salvo com sucesso!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar médico: $e'),
        ),
      );
    }
  }*/
}
