

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:WiseWallet/screens/settings/accountsettings.dart';
import 'package:flutter/material.dart';

import '../login_page.dart';


final emailController = TextEditingController();
final passwordController = TextEditingController();
var user = FirebaseAuth.instance.currentUser!;



class changeemail extends StatelessWidget {
  const changeemail({super.key});

  @override
  Widget build(BuildContext context) {
    // My Wisewallet + logo
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: const Text("Change email",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Colors.black))),
      body: SafeArea(
            child: ListView(children: [
              const SizedBox(height: 30),
              //New Email
              const Text(
                'New email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),

              ),

              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextField (
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder (
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                    labelText: 'New Email',
                  ),
                ),
              ),
              //Enter New Password

              const SizedBox(height: 30),
              const Text(
                'Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),

              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextField (
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder (
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                    labelText: 'Password',
                  ),
                ),
              ),
              //Verify New Password

              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
                child: MaterialButton(
                  height: 50,
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Change email'),
                        content: const Text('You will be logged out and an e-mail will be sent to the new address'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: ()  {
                              changeEmail(context);
                              if(FirebaseAuth.instance.currentUser?.uid == null) {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              }

                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                  color: const Color.fromARGB(255, 52, 98, 239),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              //Version Text
              const Text(
                'Version 9.20.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              ]
      ),
          ),
    );
  }
}


void changeEmail(BuildContext context) async {

  try {
    final UserCredential value = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: user.email!,
      password: passwordController.text.trim(),
    );
    if (value.user != null) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.email!,
          password: passwordController.text.trim(),);
      await value.user!.reload();
    }
  } on FirebaseAuthException catch(error) {
    if (error.code == 'email-already-in-use') {
      return print ('No user found for that email.');
    } else if (error.code == 'wrong-password') {
      return print('Wrong password provided');
    } else if (error.code == 'wrong-password'){
      return print('Email already in use');
    } else {
      return print("Sunt prost $error");
    }
  }on FirebaseException catch (r) {
    return print (r);
  }
  if (FirebaseAuth.instance.currentUser != null) {
    print(user.email);
    FirebaseAuth.instance.currentUser?.verifyBeforeUpdateEmail(
        emailController.text.trim());
    FirebaseAuth.instance.signOut();
  }
}
