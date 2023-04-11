import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Consulta {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> salvarConsulta(String nomeMedico, DateTime data, String horario,
      BuildContext context) async {
    if (nomeMedico == "" || data == "" || horario == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos'),
        ),
      );
      return;
    }

    String? usuarioId = auth.currentUser?.uid;

    QuerySnapshot consultaExistente = await _firestore
        .collection('consultas')
        .where('usuarioId', isEqualTo: usuarioId)
        .where('nomeMedico', isEqualTo: nomeMedico)
        .where('data', isEqualTo: data)
        .where('horario', isEqualTo: horario)
        .get();

    if (consultaExistente.docs.length > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Já existe uma consulta marcada para essa data e  horário,por favor selecione outra data ou horario'),
        ),
      );
    } else {
      // Se não existe uma consulta com esses dados, salva no banco de dados
      DocumentReference consultaRef =
          await _firestore.collection('consultas').add({
        'usuarioId': usuarioId,
        'nomeMedico': nomeMedico,
        'data': data,
        'horario': horario,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Consulta salva com sucesso'),
        ),
      );
    }
  }

  Future<void> _salvarConsulta(String nomeMedico, DateTime data, String horario,
      BuildContext context) async {
    if (nomeMedico == "" || data == "" || horario == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos'),
        ),
      );
      return;
    }
    String? usuarioId = auth.currentUser?.uid;

    DocumentReference consultaRef =
        await _firestore.collection('consultas').add({
      'usuarioId': usuarioId,
      'nomeMedico': nomeMedico,
      'data': data,
      'horario': horario,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('consulta salva com sucesso'),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> buscarConsultas() async {
    String? usuarioId = auth.currentUser?.uid;

    QuerySnapshot querySnapshot = await _firestore
        .collection('consultas')
        .where('usuarioId', isEqualTo: usuarioId)
        .get();

    List<Map<String, dynamic>> consultas = querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'usuarioId': doc['usuarioId'],
        'nomeMedico': doc['nomeMedico'],
        'data': doc['data'].toDate(),
        'horario': (doc['horario']),
      };
    }).toList();

    return consultas;
  }

  // ...

  Future<List<String>> getHorariosLivres(
      String nomeMedico, DateTime data) async {
    QuerySnapshot query = await _firestore
        .collection('consultas')
        .where('nomeMedico', isEqualTo: nomeMedico)
        .where('data', isEqualTo: data)
        .get();

    List<String> horariosOcupados =
        query.docs.map((doc) => doc['horario'].toString()).toList();

    List<String> horariosLivres = [];

    // Aqui você pode implementar a lógica para verificar quais horários estão livres
    // por exemplo, se a consulta dura 1 hora, você pode remover da lista de horários livres
    // os horários que já têm uma consulta marcada nesse horário ou na hora seguinte
    // (depende da sua regra de negócio)

    // Exemplo:
    List<String> horariosPossiveis = [
      '08:00',
      '09:00',
      '10:00',
      '11:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00'
    ];
    for (String horario in horariosPossiveis) {
      if (!horariosOcupados.contains(horario)) {
        horariosLivres.add(horario);
      }
    }

    return horariosLivres;
  }
}
