
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class HomeTips extends StatelessWidget {
  const HomeTips({super.key});

  Widget build(BuildContext context) {
    // My Wisewallet + logo
    return Scaffold(
        appBar: AppBar (
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
                Image.asset('assets/images/test_2.png',
                    width: 80, height: 64, alignment: Alignment.centerRight),
              ],
            )
        ),
        body: SafeArea(
          child: ListView(
            children: const [

              Divider(
                height: 1,
                thickness: 1,
              ),
            ],
          ),
        ));
  }
}
