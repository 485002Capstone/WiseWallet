// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:WiseWallet/screens/main_screen.dart';
import 'package:WiseWallet/screens/signup_screen.dart';

void main() {
  runApp(const loginpage());
}

class loginpage extends StatelessWidget {
  const loginpage({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
                    child: const Text('Log In'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MainScreen()));
                    },
                  )),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.grey[600]),
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
                    style: TextStyle(color: Colors.grey[600]),
                  )),
            ],
          ),
        )));

    // ignore: dead_code
    // void _navigateToMainScreen(BuildContext context) {
    // Navigator.of(context)
    //   .push(MaterialPageRoute(builder: (context) => MainScreen()));
  }
}
