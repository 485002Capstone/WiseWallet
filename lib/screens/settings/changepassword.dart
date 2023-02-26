import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:WiseWallet/screens/settings/accountsettings.dart';
import 'package:flutter/material.dart';

class changepassword extends StatelessWidget {
  const changepassword({super.key});

  @override
  Widget build(BuildContext context) {
    // My Wisewallet + logo
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: const Text("Change password",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Colors.black))),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(children: [
              const SizedBox(height: 30),
              //Old Password
              const Text(
                'Current Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),

              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextField (
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder (
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                    labelText: 'Old password',
                  ),
                ),
              ),
              //Enter New Password

              const SizedBox(height: 30),
              const Text(
                'Enter New Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),

              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextField (
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder (
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                    labelText: 'New password',
                  ),
                ),
              ),
              //Verify New Password
              const SizedBox(height: 30),
              const Text(
                'Verify New Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextField (
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder (
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                    labelText: 'Verify new password',
                  ),
                ),
              ),

              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.only(top: 3, left: 3),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 50,
                  onPressed: () {},
                  color: const Color.fromARGB(255, 52, 98, 239),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              //Version Text
              const Text(
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

