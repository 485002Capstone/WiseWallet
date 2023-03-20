// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

//import 'package:WiseWallet/screens/settings/PlaidScreen.dart';
import 'package:WiseWallet/screens/settings/notifications.dart';
import 'package:WiseWallet/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WiseWallet/screens/settings/accountsettings.dart';
import 'package:WiseWallet/screens/settings/themes.dart';
import 'package:WiseWallet/screens/settings/giveusfeedback.dart';
import 'package:WiseWallet/screens/login_page.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme_provider.dart';

class HomeSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // My Wisewallet + logo
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            children: <Widget>[
              Image.asset('assets/images/logofinal.png',
                  width: 70, height: 45, alignment: Alignment.topLeft),
              Text(
                'My Wisewallet',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
      body: SafeArea(
        child: ListView(children: [
          MaterialButton(
            minWidth: 50,
            height: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(width: 100, style: BorderStyle.none)),
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      duration: Duration(milliseconds: 300),
                      reverseDuration: Duration(milliseconds: 300),
                      child: accountsettings()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Account Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Icon(Icons.chevron_right)
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            indent: 45,
            endIndent: 45,
          ),
          //Notifications
          MaterialButton(
            minWidth: 50,
            height: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(
                  width: 100,
                )),
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      duration: Duration(milliseconds: 300),
                      reverseDuration: Duration(milliseconds: 300),
                      child: Notifications()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notifications",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Icon(Icons.chevron_right)
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            indent: 45,
            endIndent: 45,
          ),
          //Theme
          MaterialButton(
            minWidth: 50,
            height: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(width: 100, style: BorderStyle.none)),
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      duration: Duration(milliseconds: 300),
                      reverseDuration: Duration(milliseconds: 300),
                      child: themes()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Themes",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Icon(Icons.chevron_right)
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            indent: 45,
            endIndent: 45,
          ),
          //Give us Feedback button
          MaterialButton(
            minWidth: 50,
            height: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(width: 100, style: BorderStyle.none)),
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      duration: Duration(milliseconds: 300),
                      reverseDuration: Duration(milliseconds: 300),
                      child: feedback()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Give Us Feedback",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Icon(Icons.chevron_right)
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            indent: 45,
            endIndent: 45,
          ),
          //Currency
          MaterialButton(
            minWidth: 50,
            height: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(width: 100, style: BorderStyle.none)),
            onPressed: () {
              showCurrencyPicker(
                context: context,
                showFlag: true,
                showSearchField: true,
                showCurrencyName: true,
                showCurrencyCode: true,
                onSelect: (Currency currency) {
                  print('Select currency: ${currency.flag}');
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Currency",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Icon(Icons.menu_book)
              ],
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            indent: 45,
            endIndent: 45,
          ),
          //Terms and Conditions button
          MaterialButton(
            minWidth: 50,
            height: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(width: 100, style: BorderStyle.none)),
            onPressed: () {
              _launchUrl2();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Terms and Conditions",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Icon(Icons.link)
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            indent: 45,
            endIndent: 45,
          ),
          //About Us Button
          MaterialButton(
            minWidth: 50,
            height: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(width: 100, style: BorderStyle.none)),
            onPressed: () {
              _launchUrl();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "About Us",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Icon(Icons.link)
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            indent: 45,
            endIndent: 45,
          ),
          // Log out - Sync with firebase
          Container(
            padding: EdgeInsets.only(top: 250, bottom: 3),
            child: MaterialButton(
              minWidth: 50,
              height: 50,
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Log out'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context, "OK");
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Signed out!")));
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
              color: Color.fromARGB(255, 241, 50, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: Text(
                "Sign Out",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          //Version Text
          Text(
            'Version 9.20.0',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ]),
      ),
    );
  }
}

final Uri _url =
    Uri.parse('https://sites.google.com/view/wisewallet1/overview');

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

final Uri _url2 =
    Uri.parse('https://sites.google.com/view/wisewallet1/terms-and-conditions');

Future<void> _launchUrl2() async {
  if (!await launchUrl(_url2)) {
    throw Exception('Could not launch $_url');
  }
}
