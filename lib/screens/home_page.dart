
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});




  Widget build(BuildContext context) {
    // My Wisewallet + logo
    return Scaffold(
        appBar: AppBar (
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              children: <Widget> [
                Image.asset('assets/images/logofinal.png',
                    width: 70, height: 45, alignment: Alignment.topLeft),
                Text(
                  'Wisewallet',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
        ),
        body: SafeArea(
          child: ListView(
            children: const [],
          ),
        ));
  }
}
