import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:WiseWallet/screens/home_settings.dart';
import 'package:WiseWallet/screens/settings/changeemail.dart';
import 'package:WiseWallet/screens/settings/changepassword.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login_page.dart';


void main() {
  runApp(accountsettings());
}


class accountsettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return accountsettingsWidget();
  }

}

class accountsettingsWidget extends StatefulWidget {
  const accountsettingsWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _accountsettingsState createState() => _accountsettingsState();
}


class _accountsettingsState extends State<accountsettingsWidget> {

    var user = FirebaseAuth.instance.currentUser!;
    @override
    callBack() {
      setState(() {
        user = FirebaseAuth.instance.currentUser!;
      });
    }
    @override
    Widget build(BuildContext context) {
      // My Wisewallet + logo
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: const Text("Account Settings",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Colors.black))),
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(children: [
                const SizedBox(height: 20),
                Text(
                  user.email!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),

                ),
                //Account Setting button
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 50,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const changeemail()));
                      callBack;
                    },
                    color: const Color.fromARGB(255, 200, 199, 199),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      "Change Email",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 50,
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Change email'),
                          content: const Text('You will be logged out and instructions to change your password will be sent to your e-mail'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
                                FirebaseAuth.instance.signOut();
                                Navigator.pop(context, 'OK');
                                Navigator.pop(context, loginpage());
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ),

                    color: const Color.fromARGB(255, 200, 199, 199),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      "Change Password",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 400),
                Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 50,
                    onPressed: ()  {
                      FirebaseAuth.instance.currentUser?.delete();
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pop(loginpage());
                    },
                    color: const Color.fromARGB(255, 211, 82, 82),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      "Delete Account",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                //Version Text
                const SizedBox(height: 30),
                const Text(
                  'Version 9.20.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ]),
            )),
      );
    }
  }
