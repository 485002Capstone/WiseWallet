// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types

import 'package:WiseWallet/utils/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:WiseWallet/utils/app_theme.dart';

late var transactions;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  //Auto sign-out when the app is initialized. Uncomment once app is done ba sebi prostu
  FirebaseAuth auth = FirebaseAuth.instance;
  await auth.signOut();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// Test Comment - SP
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

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
                color: Colors.white,
                iconTheme:
                IconThemeData(color: Color.fromARGB(255, 22, 118, 41)),
                toolbarTextStyle: TextTheme(
                  headline6: TextStyle(fontSize: 20, color: Colors.white),
                ).bodyText2,
                titleTextStyle: TextTheme(
                  headline6: TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 52, 114, 93)),
                ).headline6,
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
              listTileTheme: ListTileThemeData(
                tileColor: Color.fromARGB(255, 249, 247, 249),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              // Button
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.green,
                textTheme: ButtonTextTheme.primary,
              ),
              cardTheme: CardTheme(
                color: Color.fromARGB(255, 210, 213, 210),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
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
