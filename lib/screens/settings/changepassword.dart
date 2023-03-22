// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

final oldPasswordController = TextEditingController();
final newPasswordController = TextEditingController();
final newPasswordController2 = TextEditingController();

var user = FirebaseAuth.instance.currentUser!;

class changepassword extends StatelessWidget {
  changepassword({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // My Wisewallet + logo
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text("Change password",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Column(children: [
                SizedBox(height: 30),
                //Old Password
                const Text(
                  'Current Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextFormField(
                    controller: oldPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Old password',
                    ),
                  ),
                ),
                //Enter New Password

                const Text(
                  'Enter New Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New password',
                    ),
                    validator: (value) {
                      if (value != null &&
                          value.length < 6 &&
                          value.isNotEmpty) {
                        return 'Enter min 6 characters!';
                      } else {
                        return null; //form is valid
                      }
                    },
                  ),
                ),
                //Verify New Password
                const Text(
                  'Verify New Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextFormField(
                    controller: newPasswordController2,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Verify new password',
                    ),
                    validator: (value) {
                      if (value != null &&
                          value.length < 6 &&
                          value.isNotEmpty) {
                        return 'Enter min 6 characters!';
                      } else if (value != null &&
                          value.isNotEmpty &&
                          value != newPasswordController.text.trim() &&
                          value.length != newPasswordController.text.length) {
                        return 'Passwords do not match!'; //form is valid
                      } else {
                        return null;
                      }
                    },
                  ),
                ),

                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 50,
                    onPressed: () {
                      final isValidForm = formKey.currentState!.validate();
                      if (isValidForm) {
                        changePassword(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Invalid input. Try again!")));
                      }
                    },
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
            )
          ],
        ),
      ),
    );
  }
}

Future changePassword(BuildContext context) async {
  try {
    AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!, password: oldPasswordController.text.trim());
    await user.reauthenticateWithCredential(credential);
    await FirebaseAuth.instance.currentUser
        ?.updatePassword(newPasswordController2.text.trim());
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Password changed!")));
    newPasswordController.clear();
    newPasswordController2.clear();
    oldPasswordController.clear();
  } on FirebaseAuthException catch (e) {
    if (e.code == "wrong-password") {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Wrong password")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }
}
