
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
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(4.0),
              child: Divider(
                height: 1,
                thickness: 1,
              ),
            ),
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                Text(
                  'WISEWALLET',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Image.asset('assets/images/logofinal.png',
                    width: 60, height: 50, alignment: Alignment.centerRight),
              ],
            )
        ),
        body: SafeArea(
          child: ListView(
            children: const [
              Divider(
                height: 1,
                thickness: 1,
              ),],
          ),
        ));
  }
}
