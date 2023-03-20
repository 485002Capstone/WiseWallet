
import 'dart:async';
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types

import 'package:WiseWallet/plaidService/TransactionList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:WiseWallet/plaidService/plaid_api_service.dart';

import 'main_screen.dart';


bool isConnected = false;
String accessToken = '';
late var token;
var userDocRef = FirebaseFirestore.instance.collection('accessToken').doc(FirebaseAuth.instance.currentUser?.uid);
Future main() async {

  runApp(const WalletPage());
}

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            children: <Widget> [
              Image.asset('assets/images/logofinal.png',
                  width: 70, height: 45, alignment: Alignment.topLeft),
              Text(
                'Wisewallet',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
      ),
      body: HomeWallet(),
    );
  }


}

class HomeWallet extends StatefulWidget {
  const HomeWallet({Key? key}) : super(key: key);

  @override
  _HomeWalletState createState() => _HomeWalletState();
}

class _HomeWalletState extends State<HomeWallet> {

  late String linkToken;

  LinkConfiguration? _configuration;
  StreamSubscription<LinkEvent>? _streamEvent;
  StreamSubscription<LinkExit>? _streamExit;
  StreamSubscription<LinkSuccess>? _streamSuccess;
  LinkObject? _successObject;


  @override
  void initState() {
    _streamEvent = PlaidLink.onEvent.listen(_onEvent);
    _streamExit = PlaidLink.onExit.listen(_onExit);
    _streamSuccess = PlaidLink.onSuccess.listen(_onSuccess);
    super.initState();
  }



  @override
  void dispose() {
    _streamEvent?.cancel();
    _streamExit?.cancel();
    _streamSuccess?.cancel();
    super.dispose();
  }


  void _onEvent(LinkEvent event) {
    final name = event.name;
    final metadata = event.metadata.description();
    if (kDebugMode) {
      print("onEvent: $name, metadata: $metadata");
    }
  }

  late String publicToken;

  void _onSuccess(LinkSuccess event) async{
    token = event.publicToken;
    final metadata = event.metadata.description();
    if (kDebugMode) {
      print("onSuccess: $token, metadata: $metadata");
    }
    setState(() {
      _successObject = event;
      publicToken = token;
    });

    await PlaidApiService.getAccessToken(publicToken);
    await fetchAccessToken();
    data = PlaidApiService().fetchAccountDetailsAndTransactions(accessToken);

    List<String> accountIds = event.metadata.accounts.map((account) => account.id).toList();
    await PlaidApiService().storeAccountIds(accountIds);
    if (accessToken == '') {
      _onBankAccountConnected(accessToken);
    }


  }

  void _onExit(LinkExit event) {
    final metadata = event.metadata.description();
    final error = event.error?.description();
    if (kDebugMode) {
      print("onExit metadata: $metadata, error: $error");
    }
  }


  Future<void> setLinkToken() async {
    String linkToken2 = '';
    try {

      linkToken2 = await PlaidApiService.getLinkToken();

      if (kDebugMode) {
        print('Link Token: $linkToken');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    setState(() {
      linkToken = linkToken2;
    });
  }

  Future<void> _createLinkTokenConfiguration() async {
    setState(() {
      _configuration = LinkTokenConfiguration(
        token: linkToken,
      );
    });
  }



  void _onBankAccountConnected(String accessToken) async {

    setState(() {
      isConnected = true;
      accessToken = accessToken;
    });
  }


  Future<void> fetchAccessToken() async {
    var userDocRef = FirebaseFirestore.instance.collection('accessToken').doc(FirebaseAuth.instance.currentUser?.uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    if (userDocSnapshot.exists) {
      Map<String, dynamic> userData = userDocSnapshot.data() as Map<String, dynamic>;
      if (userData.containsKey('AccessToken')) {
        if(mounted) {
          setState(() {
            isConnected = true;
            accessToken = userData['AccessToken'];
          });
        }
      }
    }
  }

  Future<void> connectBankAccount() async {
    await setLinkToken();
    await _createLinkTokenConfiguration();
    await PlaidLink.open(configuration: _configuration!);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isConnected
          ? TransactionListPage()
          : Center(
        child: ElevatedButton(
          onPressed: () async {
            await connectBankAccount();

          },
          child: Text('Connect Bank Account'),
        ),
      ),
    );
  }


}
