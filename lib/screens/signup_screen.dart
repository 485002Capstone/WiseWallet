// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types
import 'package:WiseWallet/screens/home_page.dart';
import 'package:WiseWallet/screens/login_page.dart';
import 'package:WiseWallet/screens/settings/changepassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WiseWallet/screens/main_screen.dart';
import 'package:WiseWallet/screens/signup_screen.dart';
import 'package:WiseWallet/screens/login_page.dart';
import 'package:get/get.dart';

void main() {
  runApp(SignUp());
}

class SignUp extends StatelessWidget {
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
final fullNameController = TextEditingController();
final passwordController = TextEditingController();
final passwordController2 = TextEditingController();

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<LoginWidget> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(5, 30, 5, 15),
                  child: Image.asset("assets/images/wisewalletmain.png")),
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
                      return 'Enter a valid email!';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                    ),
                    validator: (value) {
                      const valExpression = r'^((\b[a-zA-Z]{2,40}\b)\s*){2,}$';
                      final regExp = RegExp(valExpression);
                      if (!regExp.hasMatch(value!) && value.isNotEmpty) {
                        return "Name must have at least two words";
                      } else {
                        return null;
                      }
                    }),
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
                      return 'Enter min 6 characters!';
                    } else {
                      return null; //form is valid
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: passwordController2,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                  ),
                  validator: (value) {
                    if (value != null && value.length < 6 && value.isNotEmpty) {
                      return 'Enter min 6 characters!';
                    } else if (value != null &&
                        value != passwordController.text.trim() &&
                        value.isNotEmpty) {
                      return 'Passwords do not match!'; //form is valid
                    } else {
                      return null;
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
                    child: const Text('Sign Up'),
                    onPressed: () {
                      final isValidForm = formKey.currentState!.validate();
                      if (isValidForm) {
                        signUp(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Invalid input. Try again!")));
                      }
                    },
                  )),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(
                      MaterialPageRoute(builder: (context) => loginpage()));
                },
                child: Text(
                  'Already have an account?',
                ),
              ),
            ],
          ),
        ));
  }
}

Future signUp(BuildContext context) async {
  final db = FirebaseFirestore.instance;

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    FirebaseAuth.instance.currentUser
        ?.updateDisplayName(fullNameController.text.trim());
    Navigator.pop(context, "SignUp");

    await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
      'email': emailController.text.trim(),
      'full name': fullNameController.text.trim()
    });

    emailController.clear();
    passwordController.clear();
    passwordController2.clear();
    fullNameController.clear();
  } on FirebaseAuthException catch (e) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.message!)));
  }
}
