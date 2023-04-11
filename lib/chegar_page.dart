import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/views/dashboard.dart';
import 'package:flutter_application_1/views/loguin.dart';

class chegar_page extends StatefulWidget {
  const chegar_page({super.key});

  @override
  State<chegar_page> createState() => _chegar_pagestate();
}

class _chegar_pagestate extends State<chegar_page> {
  StreamSubscription? streamSubscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => login()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
      }
    });
  }

  @override
  void dispose() {
    streamSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
