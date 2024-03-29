// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WiseWallet/screens/main_screen.dart';
import 'package:WiseWallet/screens/signup_screen.dart';
import 'home_wallet.dart';

void main() {
  runApp(loginpage());
}

class loginpage extends StatelessWidget {
  const loginpage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => Scaffold(
          body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainScreen();
          } else {
            return LoginWidget();
          }
        },
      ));
}

final emailController = TextEditingController();
final passwordController = TextEditingController();

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Image.asset("assets/icons/logowisewallet.png")),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (email) {
                    if (email != null &&
                        !EmailValidator.validate(email) &&
                        email.isNotEmpty) {
                      return 'Enter a valid email';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value != null && value.length < 6 && value.isNotEmpty) {
                      return 'Enter min 6 characters';
                    } else {
                      return null; //form is valid
                    }
                  },
                ),
              ),
              Container(
                height: 80,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Log In'),
                  onPressed: () async {
                    final isValidForm = formKey.currentState!.validate();
                    if (isValidForm) {
                      await signIn(context);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Invalid input!")));
                    }
                  },
                ),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: emailController.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Instructions sent to your email")));
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'unknown') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Enter an email address")));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.message!)));
                    }
                  }
                },
                child: Text(
                  'Forgot Password?',
                ),
              ),
              TextButton(
                  // Within the `FirstRoute` widget
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Text(
                    'New around here? Sign up',
                  )),
            ],
          ),
        ));
  }

}

Future signIn(BuildContext signInContext) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    passwordController.clear();
    emailController.clear();
  } on FirebaseException catch (e) {
    if (e.code == 'user-not-found') {
      return ScaffoldMessenger.of(signInContext)
          .showSnackBar(SnackBar(content: Text("User not found")));
    } else if (e.code == 'wrong-password') {
      return ScaffoldMessenger.of(signInContext)
          .showSnackBar(SnackBar(content: Text("User not found")));
    } else if (e.code == 'unknown') {
      return ScaffoldMessenger.of(signInContext)
          .showSnackBar(SnackBar(content: Text("Enter email")));
    }
  } catch (e) {
    return ScaffoldMessenger.of(signInContext).showSnackBar(
        SnackBar(content: Text("Something went wrong. Try again!")));
  }
}
