import 'package:WiseWallet/screens/wallet/google_sheets_api.dart';
import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/main_screen.dart';
import 'screens/home_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gsheets/gsheets.dart';

//Test
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GoogleSheetsAPI().init();
  runApp(const MyApp());
}

// Test Comment - SP
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
      home: loginpage(),
    );
  }
}
