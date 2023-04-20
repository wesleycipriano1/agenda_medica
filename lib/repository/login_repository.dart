import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/medico_dashboard.dart';

import '../chegar_page.dart';

class login_repository {
  Future<UserCredential?> login(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      final String? uid = user?.uid;

      final DocumentSnapshot<Map<String, dynamic>> medicoSnapshot =
          await FirebaseFirestore.instance.collection('medicos').doc(uid).get();
      print("medicoSnapshot: $medicoSnapshot");
      final medicoData = medicoSnapshot.data();
      print("medicoData: $medicoData");

      if (medicoData != null) {
        print('medico');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Dashboard_medico()));
      } else {
        print('paciente ');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => chegar_page()));
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
