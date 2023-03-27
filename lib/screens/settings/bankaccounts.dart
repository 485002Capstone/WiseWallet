// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types
import 'package:WiseWallet/screens/home_wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../plaidService/TransactionList.dart';

class bankaccounts extends StatefulWidget {
  const bankaccounts({Key? key}) : super(key: key);

  @override
  _BankAccountsState createState() => _BankAccountsState();
}

class _BankAccountsState extends State<bankaccounts> {
  final formKey = GlobalKey<FormState>();
  var user = FirebaseAuth.instance.currentUser!;

  void setAccessTokenToNull() {
    setState(() {
      accessToken = '';
      isConnected = false;
      totalExpenses = 0;
      totalIncome = 0;
      transactionDuration = '30';
    });
  }

  // Map<String, dynamic>? _bankAccountInfo;

  // Future<void> getBankAccountInfo(String accessToken) async {
  //   const url ='https://sandbox.plaid.com/auth/get';
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       'client_id': dotenv.env['PLAID_CLIENT_ID'],
  //       'secret': dotenv.env['PLAID_SECRET'],
  //       'access_token': accessToken,
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final accountData = jsonDecode(response.body);
  //     setState(() {
  //       _bankAccountInfo = accountData['accounts'];
  //     });
  //   } else {
  //     print('Failed to fetch bank account information');
  //   }
  // }

  @override
  void initState() {
    super.initState();

    // getBankAccountInfo(accessToken);
  }

  @override
  Widget build(BuildContext context) {
    // My Wisewallet + logo
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text("Bank Accounts",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Column(children: [
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Remove bank account!'),
                      content: const Text(
                          'Are you sure you want to remove your bank account??'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            setAccessTokenToNull();
                            try {
                              await FirebaseFirestore.instance
                                  .collection("accessToken")
                                  .doc(user.uid)
                                  .delete();
                              await FirebaseFirestore.instance
                                  .collection("bankAccountIDs")
                                  .doc(user.uid)
                                  .delete();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Something went wrong try again!")));
                            }
                            Navigator.pop(context, "OK");
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Bank account removed!")));
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                  child: const Text(
                    "Remove bank account!",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
                //Version Text
              ]),
            ),
          ],
        ));
  }
}
