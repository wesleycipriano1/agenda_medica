import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          id: data['id'],
          email: data['email'],
          senha: data['senha'],
          nome: data['nome'],
          crm: data['crm'],
          especialidade: data['especialidade']));
    }

    return medicos;
  }

  Future<void> salvarMedico(Medico medico, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: medico.email,
        password: medico.senha,
      );
      medico.id = userCredential
          .user!.uid; // Atribui o ID gerado pelo Firebase Auth ao objeto Medico
      CollectionReference medicos = _firestore.collection('medicos');

      QuerySnapshot querySnapshot = await medicos
          .where('crm', isEqualTo: medico.crm)
          .where('nome', isEqualTo: medico.nome)
          .where('especialidade', isEqualTo: medico.especialidade)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await medicos.doc(medico.id).set(medico
            .toMap()); // Salva o Medico no Firestore com o ID gerado pelo Firebase Auth
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

  Future<void> _salvarMedico(Medico medico, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: medico.email,
        password: medico.senha,
      );
      Map<String, dynamic> medicoData = medico.toMap();
      medicoData['id'] = userCredential.user!.uid;
      CollectionReference medicos = _firestore.collection('medicos');

      QuerySnapshot querySnapshot = await medicos
          .where('crm', isEqualTo: medico.crm)
          .where('nome', isEqualTo: medico.nome)
          .where('especialidade', isEqualTo: medico.especialidade)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await medicos.add(medico.toMap());
        print(medico.id);
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
}
