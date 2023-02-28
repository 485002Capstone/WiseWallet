// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class HomeTips extends StatelessWidget {
  const HomeTips({super.key});

  Widget build(BuildContext context) {
    // My Wisewallet + logo
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'WISEWALLET',
                        textAlign: TextAlign.center,
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 26, 95, 28)),
                      ),
                      Image.asset('assets/images/logofinal.png',
                          width: 70, height: 45, alignment: Alignment.topRight),
                    ],
                  ),
                  // ignore: prefer_const_constructors
                  Divider(
                    color: Colors.black,
                  ),
                ]))));
  }
}
