import 'package:flutter/material.dart';
import 'package:phixlab_money/screens/home_page.dart';
import 'package:phixlab_money/screens/login_page.dart';
import 'package:phixlab_money/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WiseWallet Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const loginpage(),
    );
  }
}
