import 'package:WiseWallet/utils/theme_provider.dart';
import 'package:WiseWallet/screens/settings/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:WiseWallet/app_theme.dart';

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

// Test Comment - SP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              // General
              brightness: Brightness.light,
              primaryColor: Colors.lightBlue,
              primarySwatch: Colors.green,
              accentColor: Colors.green,
              canvasColor: Colors.white,
              backgroundColor: Colors.white,
              scaffoldBackgroundColor: Colors.white,
              errorColor: Colors.lightBlue,
              // AppBar
              appBarTheme: AppBarTheme(
                color: Colors.transparent,
                titleTextStyle: TextStyle(color: Colors.green,),
                textTheme: TextTheme(
                  headline6: TextStyle(fontSize: 20, color: Colors.white),
                ),
                iconTheme: IconThemeData(color: Colors.white),
              ),
              // FloatingActionButton
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              // Text
              textTheme: const TextTheme(
                headline1: TextStyle(fontSize: 96, fontWeight: FontWeight.w400),
                headline2: TextStyle(fontSize: 60, fontWeight: FontWeight.w400),
                headline3: TextStyle(fontSize: 48, fontWeight: FontWeight.w400),
                headline4: TextStyle(fontSize: 34, fontWeight: FontWeight.w400),
                headline5: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                subtitle1: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                subtitle2: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                bodyText1: TextStyle(fontSize: 16),
                bodyText2: TextStyle(fontSize: 14),
                caption: TextStyle(fontSize: 12),
                button: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                overline: TextStyle(fontSize: 10),
              ),

              // Button
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.green,
                textTheme: ButtonTextTheme.primary,
              ),

              // TextField
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            darkTheme: AppThemes.DarkTheme,
            home: loginpage(),
          );
        },
      ),
    );
  }
}
