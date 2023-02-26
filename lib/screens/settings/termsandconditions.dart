
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:WiseWallet/screens/home_settings.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: const Text("Terms and conditions",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Colors.black))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.only(top: 3, left: 3),
              child: ElevatedButton(
                onPressed: () {
                  _launchUrl();
                },
                child: const Text(
                  "Terms & Conditions",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 3, left: 3),
              child: ElevatedButton(
                onPressed: () {
                  _launchUrl();
                },
                child: const Text(
                  "Privacy Policy",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],)
        ),
      ),


    );
  }
}
final Uri _url = Uri.parse('https://sites.google.com/view/wisewallet1/overview');

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
