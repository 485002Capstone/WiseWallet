// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:WiseWallet/screens/settings/notifications.dart';
import 'package:flutter/material.dart';
import 'package:WiseWallet/screens/settings/currency.dart';
import 'package:WiseWallet/screens/settings/accountsettings.dart';
import 'package:WiseWallet/screens/settings/themes.dart';
import 'package:WiseWallet/screens/settings/termsandconditions.dart';
import 'package:WiseWallet/screens/settings/giveusfeedback.dart';
import 'package:WiseWallet/screens/settings/aboutus.dart';
import 'package:WiseWallet/screens/login_page.dart';

class HomeSettings extends StatelessWidget {
  const HomeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    // My Wisewallet + logo
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Wisewallet',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset('assets/images/logofinal.png',
                  width: 70, height: 45, alignment: Alignment.topRight),
            ],
          ),
          Divider(
            color: Colors.black,
          ),
          //Account Setting button
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 50,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const accountsettings()));
              },
              color: Color.fromARGB(255, 200, 199, 199),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Account Settings",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          //Notifications
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 50,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Notifications()));
              },
              color: Color.fromARGB(255, 200, 199, 199),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Notifications",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          //Currency
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 50,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => currency()));
              },
              color: Color.fromARGB(255, 200, 199, 199),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Currency",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          //Theme
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 50,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const themes()));
              },
              color: Color.fromARGB(255, 200, 199, 199),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Themes",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(height: 35),
          Divider(
            color: Colors.black,
          ),
          //Terms and Conditions button
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 50,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const termsandconditions()));
              },
              color: Color.fromARGB(255, 200, 199, 199),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Terms and Conditions",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          //Give us Feedback button
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 50,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const feedback()));
              },
              color: Color.fromARGB(255, 200, 199, 199),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Give Us Feedback",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          //About Us Button
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            child: MaterialButton(
              minWidth: double.infinity,
              height: 50,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const aboutus()));
              },
              color: Color.fromARGB(255, 200, 199, 199),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "About Us",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          // Log out - Sync with firebase
          SizedBox(height: 28),
          Container(
            padding: EdgeInsets.only(top: 3, left: 3),
            child: MaterialButton(
              minWidth: 50,
              height: 50,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const loginpage()));
              },
              color: Color.fromARGB(255, 241, 50, 36),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                "Log Out",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          //Version Text
          SizedBox(height: 8),
          Text(
            'Version 9.20.0',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ]),
      )),
    );
  }
}
