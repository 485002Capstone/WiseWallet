import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:WiseWallet/screens/home_page.dart';
import 'package:WiseWallet/screens/home_settings.dart';
import 'package:WiseWallet/screens/home_tips.dart';
import 'package:WiseWallet/screens/home_wallet.dart';
import 'package:WiseWallet/screens/login_page.dart';
import 'package:WiseWallet/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore_for_file: camel_case_types
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_const_constructors
import '../theme_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainScreen> {



  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //
  // String? mtoken = " ";
  //
  //
  // @override
  // void initState() {
  //   super.initState();
  //   requestPermission();
  //   getToken();
  //
  // }

//   void requestPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
// }
//
//   void getToken() async {
//     await FirebaseMessaging.instance.getToken().then(
//         (token) {
//           setState(() {
//             mtoken = token;
//             print("My token is $mtoken");
//           });
//           saveToken(token!);
//         }
//     );
//   }
//
//   void saveToken (String token) async {
//     await FirebaseFirestore.instance.collection("UserTokens").doc(FirebaseAuth.instance.currentUser?.uid).set({
//       'token' : token,
//     });
//   }
//
//   initInfo() {
//     var androidinitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOSInitialize = const IOSInitializationSettings();
//     var initializationSettings = InitializationSettings(android: androidinitialize);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotifications: )
//   };

  var currentIndex = 0;

  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const HomeWallet();
      case 2:
        return const HomeTips();
      case 3:
        return HomeSettings();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
     theme: ThemeData(
       appBarTheme: const AppBarTheme(color: Colors.transparent),
       inputDecorationTheme: InputDecorationTheme(enabledBorder: OutlineInputBorder(
           borderSide: BorderSide(color: Colors.green)),
           focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green))),

       colorScheme: ColorScheme(
         brightness: Brightness.light,
         primary: Colors.green,
         onPrimary: Colors.black,
         background: Colors.transparent,
         onBackground: Colors.black,
         error: Colors.black,
         onError: const Color(0xFFBA1A1A),
         secondary: Colors.black,
         onSecondary: Colors.green,
         surface: Colors.black,
         onSurface: Colors.green,

       ),
     ),

     home: Scaffold(
      body: buildTabContent(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
         },
         selectedItemColor: secondaryDark,
         unselectedItemColor: fontLight,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.wallet), label: "Wallet"),
          // BottomNavigationBarItem(
          //   icon: Image.asset("assets/icons/plus.png"), label: "Plus"),
          BottomNavigationBarItem(
              icon: Icon(Icons.tips_and_updates), label: "Tips"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings"),
        ],
      ),
    ),
  );
}
