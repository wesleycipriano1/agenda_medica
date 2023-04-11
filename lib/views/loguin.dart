import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chegar_page.dart';
import 'package:flutter_application_1/views/cadastro_page.dart';
import 'package:flutter_application_1/views/recuperar_senha.dart';

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _emailController = TextEditingController();
  final _senhaContoller = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 150,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _senhaContoller,
                decoration: InputDecoration(
                  hintText: 'Senha',
                  prefixIcon: Icon(Icons.lock),

                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white, // cor da borda do campo de senha
                      width: 1.0, // largura da borda do campo de senha
                    ),
                    borderRadius: BorderRadius.circular(
                        10.0), // borda do campo de senha arredondada
                  ),
                  filled: true,
                  fillColor: Colors.white
                      .withOpacity(0.7), // cor de fundo do campo de senha
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Resetar_senha()));
                  },
                  child: Text(
                    'Recuperar Senha',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  login();
                },
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => cadastro_page()));
                },
                child: Text(
                  'Cadastrar-se',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: _emailController.text, password: _senhaContoller.text);

      if (userCredential != null) {
        print(userCredential);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => chegar_page()));
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("usuario não encontrado"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("senha invalida"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == "network-request-failed") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(" sem conexão com a rede"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}



















































/*import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/chegar_page.dart';
import 'package:flutter_application_1/views/cadastro_page.dart';
import 'package:flutter_application_1/views/cadastro_foto.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _login();
}

class _login extends State<login> {
  final _emailController = TextEditingController();
  final _senhaContoller = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60, left: 40, right: 40),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset("assets/logo.jpg"),
            ),
            TextFormField(
              controller: _emailController,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "email",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 20)),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _senhaContoller,
              // autofocus: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "senha",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 20)),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 20,
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  onPressed: () {}, child: Text("recuperar senha")),
            ),
            SizedBox(
              height: 60,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: SizedBox.expand(
                child: ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          child: SizedBox(
                            child: Image.asset("assets/login.png"),
                            height: 28,
                            width: 28,
                          ),
                        )
                      ],
                    )),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 20,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.transparent),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => cadastro_page()));
                    ;
                  },
                  child: Text(
                    "cadastra-se",
                    textAlign: TextAlign.center,
                  )),
            )
          ],
        ),
      ),
    );
  }

  login() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: _emailController.text, password: _senhaContoller.text);

      if (userCredential != null) {
        print(userCredential);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => chegar_page()));
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("usuario não encontrado"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("senha invalida"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == "network-request-failed") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(" sem conexão com a rede"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
 
//}
//class loguin extends StatelessWidget {
  //final _emailController = TextEditingController();
  //final _senhaContoller = TextEditingController();
  //final _firebaseAuth = FirebaseAuth.instance;
*/

