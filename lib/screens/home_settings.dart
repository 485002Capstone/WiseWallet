// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types

import 'package:WiseWallet/screens/settings/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WiseWallet/screens/settings/accountsettings.dart';
import 'package:WiseWallet/screens/settings/themes.dart';
import 'package:WiseWallet/screens/settings/giveusfeedback.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:WiseWallet/screens/home_wallet.dart';

class HomeSettings extends StatelessWidget {
  const HomeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'MY WISEWALLET',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Image.asset('assets/images/logofinal.png',
                  width: 50, height: 40, alignment: Alignment.centerRight),
            ],
          )),
      body: Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _HomeSettingsState createState() => _HomeSettingsState();
}

class _HomeSettingsState extends State<Settings> {
  void setAccessTokenToNull() {
    setState(() {
      accessToken = '';
      isConnected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // My Wisewallet + logo
    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverToBoxAdapter(
          child: Column(children: [
            Divider(
              height: 1,
              thickness: 1,
            ),
            MaterialButton(
              elevation: 0,
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
                  Icon(
                    Icons.chevron_right,
                  )
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
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
            ),
            // Log out - Sync with firebase
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2,
                  bottom: MediaQuery.of(context).size.height * 0.001),
              child: MaterialButton(
                minWidth: double.infinity,
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
                          setAccessTokenToNull();
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
                      fontSize: 18 * MediaQuery.of(context).textScaleFactor),
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
      ],
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
