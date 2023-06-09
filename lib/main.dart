import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chegar_page.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/views/agendamento.dart';
import 'package:flutter_application_1/views/inicio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(myAPP());
}

class myAPP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wesc consultorio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: inicio_page(),
    );
  }
}
