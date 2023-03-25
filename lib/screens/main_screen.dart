// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WiseWallet/screens/home_page.dart';
import 'package:WiseWallet/screens/home_settings.dart';
import 'package:WiseWallet/screens/home_tips.dart';
import 'package:WiseWallet/screens/home_wallet.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../plaidService/TransactionList.dart';
import '../plaidService/plaid_api_service.dart';
import 'package:http/http.dart' as http;

late Future<List<dynamic>>? transactionsFuture;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MyWidgetState();
}

var currentIndex = 0;
late Future<Map<String, dynamic>> data;
int pageIndex = 0;
class _MyWidgetState extends State<MainScreen> {
  final PageController pageController = PageController();
  @override
  void initState() {
    initializeWalletVariables().then((_){
      getTransactions(accessToken, days);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'WISEWALLET',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Image.asset('assets/images/logofinal.png',
                  width: 60, height: 50, alignment: Alignment.centerRight),
            ],
          )),
      body: PageView(
        controller: pageController,
        onPageChanged: (pageIndex) {
          setState(() {
            currentIndex = pageIndex;
          });
        },
        children: [
          HomePage(),
          WalletPage(),
          TipsPage(),
          HomeSettings(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (pageIndex) {
          setState(() {
            currentIndex = pageIndex;
          });
          pageController.animateToPage(
            pageIndex,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },

        selectedItemColor:
            isDarkMode ? Colors.orangeAccent : Color.fromARGB(255, 52, 114, 93),
        unselectedItemColor: isDarkMode ? Colors.orange[200] : Colors.grey,
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
  }

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
            days = 30;
            data = PlaidApiService()
                .fetchAccountDetailsAndTransactions(accessToken);
            transactionsFuture =
                PlaidApiService.getTransactions(accessToken, days);
          });
        }
      }
    }
  }

  Future<void> getTransactions(String accessToken, int days) async {
    const _baseUrl = 'https://sandbox.plaid.com';
    final startDate = DateTime.now()
        .subtract(Duration(days: days))
        .toIso8601String()
        .substring(0, 10);
    final endDate = DateTime.now().toIso8601String().substring(0, 10);

    final response = await http.post(
      Uri.parse('$_baseUrl/transactions/get'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'client_id': dotenv.env['PLAID_CLIENT_ID'],
        'secret': dotenv.env['PLAID_SECRET'],
        'access_token': accessToken,
        'start_date': startDate,
        'end_date': endDate,
      }),
    );

    if (response.statusCode == 200) {
      final transactionsList = await json.decode(response.body);
      if (mounted) {
        setState(() {
          transactions = transactionsList['transactions'];
          expenseTransactions =
              transactionsList['transactions'].cast<Map<String, dynamic>>();
        });
      }
      for (var transaction in expenseTransactions) {
        double amount = transaction['amount'].toDouble();
        if (amount > 0) {
          setState(() {
            totalIncome += amount;
          });
        } else {
          setState(() {
            totalExpenses += amount.abs();
          });
        }
      }
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }
}
