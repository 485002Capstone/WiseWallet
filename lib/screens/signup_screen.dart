// ignore_for_file: camel_case_types

import 'package:WiseWallet/screens/home_page.dart';
import 'package:WiseWallet/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WiseWallet/screens/main_screen.dart';
import 'package:WiseWallet/screens/signup_screen.dart';
import 'package:WiseWallet/screens/login_page.dart';
void main() {
  runApp(SignUp());
}


class SignUp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => Scaffold (
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainScreen();
          } else {
            return LoginWidget();
          }
        },
      )
  );
}

final emailController = TextEditingController();
final passwordController = TextEditingController();
class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});


  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<LoginWidget> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'WiseWallet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
                      child: Image.asset("assets/icons/logowisewallet.png")),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Container(
                      height: 80,
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Sign Up'),
                        onPressed: () {
                          signUp();
                        },
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(MaterialPageRoute(
                          builder: (context) => loginpage()));
                    },
                    child: Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            )));

  }

}

Future signUp() async {
  try {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: emailController.text.trim(),
    password: passwordController.text.trim(),
  );
  }on FirebaseAuthException catch (e) {
    print (e);
  }
}
