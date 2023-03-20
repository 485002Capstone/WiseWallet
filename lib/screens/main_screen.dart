// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WiseWallet/screens/home_page.dart';
import 'package:WiseWallet/screens/home_settings.dart';
import 'package:WiseWallet/screens/home_tips.dart';
import 'package:WiseWallet/screens/home_wallet.dart';
import '../app_theme.dart';
import '../plaidService/TransactionList.dart';
import '../plaidService/plaid_api_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MyWidgetState();
}

late Future<Map<String, dynamic>> data;

class _MyWidgetState extends State<MainScreen> {
  @override
  void initState() {
    initializeWalletVariables();
    super.initState();
  }

  var currentIndex = 0;

  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return WalletPage();
      case 2:
        return const HomeTips();
      case 3:
        return HomeSettings();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: buildTabContent(currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          selectedItemColor: fontDark,
          unselectedItemColor: fontLight,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
            BottomNavigationBarItem(
                icon: Icon(Icons.tips_and_updates), label: "Tips"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
      );

  Future<void> initializeWalletVariables() async {
    var userDocRef = FirebaseFirestore.instance
        .collection('accessToken')
        .doc(FirebaseAuth.instance.currentUser?.uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    if (userDocSnapshot.exists) {
      Map<String, dynamic> userData =
          userDocSnapshot.data() as Map<String, dynamic>;
      if (userData.containsKey('AccessToken')) {
        if (mounted) {
          setState(() {
            isConnected = true;
            accessToken = userData['AccessToken'];
            data = PlaidApiService()
                .fetchAccountDetailsAndTransactions(accessToken);
          });
        }
      }
    }
  }
}
