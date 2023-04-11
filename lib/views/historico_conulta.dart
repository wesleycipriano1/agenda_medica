import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/consulta.dart';
import 'package:intl/intl.dart';

class HistoricoConsultas extends StatefulWidget {
  @override
  _HistoricoConsultasState createState() => _HistoricoConsultasState();
}

class _HistoricoConsultasState extends State<HistoricoConsultas> {
  Consulta consulta_ = Consulta();
  List<Map<String, dynamic>> _consultas = [];

  @override
  void initState() {
    super.initState();
    carregarConsultas();
    //teste
  }

  Future<void> carregarConsultas() async {
    List<Map<String, dynamic>> consultas = await consulta_.buscarConsultas();
    setState(() {
      _consultas = consultas;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_consultas.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(' Minhas consultas '),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today_outlined, size: 80),
              SizedBox(height: 16),
              Text(
                'Ops!Parece que  você ainda não tem  hisotrico de consultas.',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(' Minhas consultas '),
      ),
      body: ListView.builder(
        itemCount: _consultas.length,
        itemBuilder: (context, index) {
          final consulta = _consultas[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "medico: " + consulta['nomeMedico'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  "data da consulta: " +
                      DateFormat('dd/MM/yyyy').format(consulta['data']),
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  "horario : " + (consulta['horario']),
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
