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
var userDocRef = FirebaseFirestore.instance
    .collection('accessToken')
    .doc(FirebaseAuth.instance.currentUser?.uid);

Future main() async {
  runApp(const WalletPage());
}

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:HomeWallet(),
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

  void _onSuccess(LinkSuccess event) async {
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

    List<String> accountIds =
        event.metadata.accounts.map((account) => account.id).toList();
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
          });
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isConnected
            ? TransactionListPage()
            : CustomScrollView(
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0),
                              child: Card(
                                child: SizedBox(
                                    width: 350,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            'Checking',
                                            style:
                                            TextStyle(fontSize: 16),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Available',
                                                style: TextStyle(
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                '\$2000',
                                                style: TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Card(
                      elevation: 4,
                      margin: EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Transactions',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await connectBankAccount();
                                  },
                                  child: Text('Connect Bank Account'),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text('Uber'),
                                      trailing: Text(
                                        '\$25',
                                      ),
                                      subtitle: Text('Date: 2023-03-14'),
                                    ),
                                    ListTile(
                                      title: Text('Uber'),
                                      trailing: Text(
                                        '\$25',
                                      ),
                                      subtitle: Text('Date: 2023-03-14'),
                                    ),
                                    ListTile(
                                      title: Text('McDonald\'s'),
                                      trailing: Text(
                                        '\$15.2',
                                      ),
                                      subtitle: Text('Date: 2023-03-14'),
                                    ),
                                    ListTile(
                                      title: Text('Wage'),
                                      trailing: Text(
                                        '\$+850',
                                        style: TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                      subtitle: Text('Date: 2023-03-14'),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                            child: Card(
                              child: ListTile(
                                title: Text('Expense'),
                                subtitle: Text(
                                  '\$3000',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )),
                        Expanded(
                            child: Card(
                              child:
                              ListTile(
                                title: Text('Income'),
                                subtitle: Text(
                                  '\$1200',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),


                            )),
                      ],
                    ),
                  ],
                ),
            )
          ],


    )
    );
}
  Future<void> connectBankAccount() async {
    await setLinkToken();
    await _createLinkTokenConfiguration();
    await PlaidLink.open(configuration: _configuration!);
  }
}
