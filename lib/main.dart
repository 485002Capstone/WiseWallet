// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types

import 'dart:async';
import 'dart:io';
import 'package:WiseWallet/utils/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:WiseWallet/utils/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late var transactions;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> printFcmToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $token');
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  /* FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  final messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  printFcmToken(); */

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
              backgroundColor: Colors.green,
              scaffoldBackgroundColor: Colors.white,
              errorColor: Colors.lightBlue,
              // AppBar
              appBarTheme: AppBarTheme(
                color: Colors.white,
                iconTheme:
                    IconThemeData(color: Color.fromARGB(90, 134, 255, 130)),
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
                tileColor: HexColor('#e1f2e9'),
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
                color: Color.fromARGB(255, 255, 255, 255),
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('channel_id', 'channel_name',
          importance: Importance.max, priority: Priority.high, showWhen: false);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
      message.notification?.body, platformChannelSpecifics,
      payload: 'item x');
}
