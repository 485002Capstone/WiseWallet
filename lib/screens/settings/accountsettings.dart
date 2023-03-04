import 'dart:async';
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:WiseWallet/screens/home_settings.dart';
import 'package:WiseWallet/screens/settings/changeemail.dart';
import 'package:WiseWallet/screens/settings/changepassword.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';

import '../login_page.dart';

final _db = FirebaseFirestore.instance;
final docRef = _db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid);

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
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: const Text("Account Settings",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        body: SafeArea(
              child: ListView(children: [
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
                Divider(
                  color: Colors.black12,
                  height: 1,
                  thickness: 1,
                ),
                Container(
                  child: MaterialButton(
                    minWidth: 50,
                    height: 50,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(
                            width: 100,
                            style: BorderStyle.none
                        )),
                    onPressed: () {
                      Navigator.push(context, PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          duration: Duration(milliseconds: 300),
                          reverseDuration: Duration(milliseconds: 300),
                          child: changeemail()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Change Email",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        Image.asset('assets/icons/right_chevron.png',
                            width: 15, height: 15, alignment: Alignment.centerRight),
                      ],),
                  ),
                ),
                Divider(
                  color: Colors.black12,
                  height: 1,
                  thickness: 1,
                  indent: 45,
                  endIndent: 45,
                ),
                Container(
                  child: MaterialButton(
                    minWidth: 50,
                    height: 50,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(
                            width: 100,
                            color: Colors.blue,
                            style: BorderStyle.none
                        )),
                    onPressed: ()  {
                      Navigator.push(context, PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          duration: Duration(milliseconds: 300),
                          reverseDuration: Duration(milliseconds: 300),
                          child: changepassword()));
                    },
                    // => showDialog<String>(
                    //   context: context,
                    //   builder: (BuildContext context) => AlertDialog(
                    //     title: const Text('Change password'),
                    //     content: const Text('You will be logged out and instructions to change your password will be sent to your e-mail'),
                    //     actions: <Widget>[
                    //       TextButton(
                    //         onPressed: () => Navigator.pop(context, 'Cancel'),
                    //         child: const Text('Cancel'),
                    //       ),
                    //       TextButton(
                    //         onPressed: () async {
                    //           FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
                    //           FirebaseAuth.instance.signOut();
                    //           Navigator.pop(context, 'OK');
                    //           Navigator.pop(context, loginpage());
                    //         },
                    //         child: const Text('OK'),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Change Password",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        Image.asset('assets/icons/right_chevron.png',
                            width: 15, height: 15, alignment: Alignment.centerRight),
                      ],),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 50, bottom: 5),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 50,
                    onPressed: ()  {
                      FirebaseAuth.instance.currentUser?.delete();
                      FirebaseAuth.instance.signOut();
                      FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).delete();
                      Navigator.of(context).pop(loginpage());
                    },
                    color: Color.fromARGB(255, 241, 50, 36),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
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
                const SizedBox(height: 8),
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
      );
    }
  }
