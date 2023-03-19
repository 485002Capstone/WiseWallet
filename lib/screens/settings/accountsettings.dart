import 'dart:async';

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types
import 'package:WiseWallet/screens/settings/bankaccounts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:WiseWallet/screens/settings/changeemail.dart';
import 'package:WiseWallet/screens/settings/changepassword.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';

import '../login_page.dart';

final _db = FirebaseFirestore.instance;

class accountsettings extends StatelessWidget {

  var user = FirebaseAuth.instance.currentUser!;

  accountsettings({super.key});

  final docRef = _db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid);
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // My Wisewallet + logo
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: const Text("Account Settings",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  )),
          leading: IconButton (
            icon: Icon(Icons.arrow_back_ios_new),
            iconSize: 20.0,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ) ,
      body: SafeArea(
        child: ListView(children: [
          const SizedBox(height: 20),
          Text(

            "Hello, ${user.displayName}!",
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
                  Icon(
                    Icons.chevron_right
                  )
                ],),
            ),
          ),
          Divider(
            color: Colors.black12,
            height: 1,
            thickness: 1,
            endIndent: 45,
          ),
          Container(
            child: MaterialButton(
              minWidth: 50,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(
                      width: 100,
                      style: BorderStyle.none
                  )),
              onPressed: ()  {
                Navigator.push(context, PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    duration: Duration(milliseconds: 300),
                    reverseDuration: Duration(milliseconds: 300),
                    child: changepassword()));
              },
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
                  Icon(
                      Icons.chevron_right
                  )
                ],),
            ),
          ),
          Divider(
            color: Colors.black12,
            height: 1,
            thickness: 1,
            endIndent: 45,
          ),
          Container(
            child: MaterialButton(
              minWidth: 50,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(
                      width: 100,
                      style: BorderStyle.none
                  )),
              onPressed: ()  {
                Navigator.push(context, PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    duration: Duration(milliseconds: 300),
                    reverseDuration: Duration(milliseconds: 300),
                    child: bankaccounts()));
              },
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bank Accounts",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  Icon(
                      Icons.chevron_right
                  )
                ],),
            ),
          ),
          Divider(
            color: Colors.black12,
            height: 1,
            thickness: 1,
          ),
          Container(
            padding: EdgeInsets.only(top: 50, bottom: 5),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 50,

              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Change email'),
                  content: const Text('Introduce your password'),
                  actions: <Widget>[
                    TextField (
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder (
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Password',
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: ()  {
                        deleteAccount(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
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

Future deleteAccount(BuildContext context) async {
  try {
    AuthCredential credential = EmailAuthProvider.credential(
        email: accountsettings().user.email!, password: accountsettings().passwordController.text.trim());
    await accountsettings().user.reauthenticateWithCredential(credential);
    FirebaseAuth.instance.currentUser?.delete();
    FirebaseAuth.instance.signOut();
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).delete();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Account deleted!")));
    accountsettings().passwordController.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => loginpage()),
          (Route<dynamic> route) => false,
    );
  }on FirebaseAuthException catch (e){
    if (e.code == "wrong-password") {
      Navigator.pop(context, 'OK');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Wrong password")));
    }else {
      Navigator.pop(context, 'OK');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }
}