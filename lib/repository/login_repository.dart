import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login_repository {
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      final String? uid = user?.uid;

      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = snapshot.data();
      if (data != null && data.containsKey('crm') && data['crm'] != null) {
        // usuário é médico
        // navegue para a tela de dashboard do médico
      } else {
        // usuário é paciente
        // navegue para a tela de dashboard do paciente
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
