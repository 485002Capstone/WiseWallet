import 'package:flutter/material.dart';

class homesettings extends StatelessWidget {
  const homesettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(children: [
          Text(
            'My Wisewallet',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ]),
      )),
    );
  }
}
