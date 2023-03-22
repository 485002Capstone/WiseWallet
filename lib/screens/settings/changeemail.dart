// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types
import 'package:email_validator/email_validator.dart';
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

void main() {
  runApp(changeemail());
}

class changeemail extends StatelessWidget {
  changeemail({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // My Wisewallet + logo
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text("Change email",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Column(children: [
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
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'New Email',
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
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
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
                        content: const Text(
                            'You will be logged out and an e-mail will be sent to the new address'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              final isValidForm =
                                  formKey.currentState!.validate();
                              if (isValidForm) {
                                changeEmail(context);
                              } else {
                                Navigator.pop(context, "OK");
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Invalid input. Try again!")));
                              }
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                    color: const Color.fromARGB(255, 52, 98, 239),
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
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

Future changeEmail(BuildContext context) async {
  try {
    AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!, password: passwordController.text.trim());
    await user.reauthenticateWithCredential(credential);
    await FirebaseAuth.instance.currentUser
        ?.verifyBeforeUpdateEmail(emailController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Email verification was sent to the new email")));
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => loginpage()),
      (Route<dynamic> route) => false,
    );
    emailController.clear();
    passwordController.clear();
  } on FirebaseAuthException catch (e) {
    if (e.code == 'unknown') {
      Navigator.pop(context, 'OK');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter an email address")));
    } else {
      Navigator.pop(context, 'OK');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  // if (FirebaseAuth.instance.currentUser?.uid != null) {
  //   print(user.email);
  //   FirebaseAuth.instance.currentUser?.verifyBeforeUpdateEmail(
  //       emailController.text.trim());
  //   FirebaseAuth.instance.signOut();
  // }
}
