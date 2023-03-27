import 'package:flutter/material.dart';

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types

class AppThemes {
  static final ThemeData themeLight = ThemeData(
    // // General
    // brightness: Brightness.light,
    // primarySwatch: Colors.red,
    // primaryColor: Colors.red,
    // accentColor: Colors.red,
    // canvasColor: Colors.red,
    // backgroundColor: Colors.red,
    // scaffoldBackgroundColor: Colors.red,
    // errorColor: Colors.red,
    //
    // // AppBar
    // appBarTheme: AppBarTheme(
    //   color: Colors.red,
    //   textTheme: TextTheme(
    //     headline6: TextStyle(fontSize: 20, color: Colors.white),
    //   ),
    //   iconTheme: IconThemeData(color: Colors.white),
    // ),
    //
    // // FloatingActionButton
    // floatingActionButtonTheme: FloatingActionButtonThemeData(
    //   backgroundColor: Colors.blue,
    //   foregroundColor: Colors.white,
    // ),
    //
    // // Text
    // textTheme: TextTheme(
    //   headline1: TextStyle(fontSize: 96, fontWeight: FontWeight.bold),
    //   headline2: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
    //   headline3: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
    //   headline4: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
    //   headline5: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //   headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    //   subtitle1: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    //   subtitle2: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    //   bodyText1: TextStyle(fontSize: 16),
    //   bodyText2: TextStyle(fontSize: 14),
    //   caption: TextStyle(fontSize: 12),
    //   button: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    //   overline: TextStyle(fontSize: 10),
    // ),
    //
    // // Button
    // buttonTheme: ButtonThemeData(
    //   buttonColor: Colors.red,
    //   textTheme: ButtonTextTheme.primary,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(15),
    //   ),
    // ),
    //
    // // TextField
    // inputDecorationTheme: InputDecorationTheme(
    //   border: OutlineInputBorder(
    //     borderSide: BorderSide(color: Colors.red),
    //     borderRadius: BorderRadius.circular(15),
    //   ),
    //   focusedBorder: OutlineInputBorder(
    //     borderSide: BorderSide(color: Colors.blue),
    //     borderRadius: BorderRadius.circular(15),
    //   ),
    // ),
    brightness: Brightness.light,
  );

  static final ThemeData DarkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    accentColor: Colors.red,
    iconTheme: const IconThemeData(color: Colors.blue),
    // Add other customizations as needed
  );
}

const Color fontDark = Color(0xFF502929);
const Color fontLight = Color(0xFF0053E8);
