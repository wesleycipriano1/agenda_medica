import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/medico.dart';
import 'package:flutter_application_1/repository/medico_repository.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/repository/consulta.dart';

class AgendamentoConsulta extends StatefulWidget {
  @override
  _AgendamentoConsultaState createState() => _AgendamentoConsultaState();
}

class _AgendamentoConsultaState extends State<AgendamentoConsulta> {
  //List<String> _medicos = [];
  //List<Medico> listaMedicos = [];
  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final medicoRepository = MedicoRepository();
  final Consulta _consulta = Consulta();
  List<Medico> listaMedicos = [];
  late DateTime _data;

  final String nome_medico = "";
  final String horario_selecionado = "";

  @override
  void initState() {
    super.initState();
    _carregarMedicos();

    /*FirebaseFirestore.instance
        .collection('medicos')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final medico = Medico(
          nome: doc['nome'],
          crm: doc['crm'],
          especialidade: doc['especialidade'],
        );
        setState(() {
          medicos.add(medico);
        });
      });
    });*/
  }

  String? _selectedMedico;
  List<String> _horarios = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00'
  ];
  String? _selectedHorario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamento de Consulta'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Escolha o médico:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedMedico,
              items: listaMedicos.map((medico) {
                return DropdownMenuItem<String>(
                  value: medico.nome,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medico.nome,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //SizedBox(width: 200.0),
                      Text(
                        medico.especialidade,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMedico = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Escolha o horário:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedHorario,
              items: _horarios.map((horario) {
                return DropdownMenuItem<String>(
                  value: horario,
                  child: Text(horario),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedHorario = value;
                });
              },
            ),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Data',
                hintText: 'dd/mm/yyyy',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Informe uma data válida';
                }
                return null;
              },
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null && pickedDate != _selectedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                    _dateController.text =
                        DateFormat('dd/MM/yyyy').format(_selectedDate);
                  });
                }
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Agendar consulta'),
              onPressed: _selectedMedico != null && _selectedHorario != null
                  ? () {
                      DateTime date =
                          DateFormat('dd/MM/yyyy').parse(_dateController.text);
                      _data = date;

                      _consulta.salvarConsulta(_selectedMedico.toString(), date,
                          _selectedHorario.toString(), context);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _carregarMedicos() async {
    List<Medico> _listaMedicos = await medicoRepository.getMedicos();
    setState(() {
      listaMedicos = _listaMedicos;
    });
  }
}
