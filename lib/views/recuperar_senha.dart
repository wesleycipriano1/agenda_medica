import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Resetar_senha extends StatefulWidget {
  @override
  _Resetar_senhaState createState() => _Resetar_senhaState();
}

class _Resetar_senhaState extends State<Resetar_senha> {
  final TextEditingController _emailController = TextEditingController();

  void _resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('E-mail de redefinição de senha enviado com sucesso!'),
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar e-mail de redefinição de senha: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redefinir senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-mail',
                hintText: 'Digite seu e-mail',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Campo obrigatório';
                }
                if (!value.contains('@')) {
                  return 'E-mail inválido';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Redefinir senha'),
            ),
          ],
        ),
      ),
    );
  }
}
