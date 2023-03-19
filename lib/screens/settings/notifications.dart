
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: const Text("Notifications",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800)),
        leading: IconButton (
          icon: Icon(Icons.arrow_back_ios_new),
          iconSize: 20.0,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(children: const [
              SizedBox(height: 20),
              Text(
                'Email@gmail.com',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              //Version Text
            ]),
          )),
    );
  }
}
