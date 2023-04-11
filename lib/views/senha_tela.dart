import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/repository/usuario.dart';

class senha_tela extends StatefulWidget {
  @override
  _senha_telaState createState() => _senha_telaState();
}

class _senha_telaState extends State<senha_tela> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  Future<void> changePassword(String oldPassword, String newPassword) async {
    User user = FirebaseAuth.instance.currentUser!;

    // Cria uma credencial com o email e senha do usuário logado
    AuthCredential credential =
        EmailAuthProvider.credential(email: user.email!, password: oldPassword);

    try {
      // Reautentica o usuário com a credencial criada
      AuthCredential authCredential = EmailAuthProvider.credential(
          email: user.email!, password: oldPassword);
      await user.reauthenticateWithCredential(authCredential);

      // Atualiza a senha do usuário
      await user.updatePassword(newPassword);

      // Exibe a mensagem de sucesso
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Senha alterada com sucesso!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sua nova senha é: $newPassword'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("senha invalida, não corresponde a senha atual"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "verifique os campos e tente novamente, a nova senha deve possuir no minimo 6 digitos "),
            backgroundColor: Colors.redAccent,
          ),
        );
        print('Ocorreu um erro ao alterar a senha: $e');
      }
    } catch (e) {
      print('Ocorreu um erro ao alterar a senha: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar Senha'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha Antiga',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nova Senha',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _confirmChangePassword();
              },
              child: Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmChangePassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alterar Senha'),
          content: Text('Deseja realmente alterar sua senha?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _changePassword();
                Navigator.pop(context);
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _changePassword() {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;

    changePassword(oldPassword, newPassword);
    print('Senha antiga: $oldPassword');
    print('Nova senha: $newPassword');
  }
}
