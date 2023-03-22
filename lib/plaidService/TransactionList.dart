import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:page_transition/page_transition.dart';
import '../screens/home_wallet.dart';
import 'detailedAccount.dart';
import 'plaid_api_service.dart';
import 'package:http/http.dart' as http;
import 'package:WiseWallet/screens/main_screen.dart';

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types

const _baseUrl = 'https://sandbox.plaid.com';
const List<String> list = <String>['7', '30', '60','90', '420'];

String? transactionDuration = '7';
int days = 7;

List<dynamic> _transactions = [];

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key? key}) : super(key: key);

  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> accounts = snapshot.data!['accounts'];
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          PlaidApiService().printCountSpentPerCategory();
                          PlaidApiService().printCountCategory();
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeftWithFade,
                                  duration: Duration(milliseconds: 300),
                                  reverseDuration: Duration(milliseconds: 300),
                                  child: detailedAccount(
                                    account: accounts[index],
                                  )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Card(
                            child: SizedBox(
                                width: 350,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${accounts[index]['name']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Available',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            '\$${accounts[index]['balances']['available']}',
                                            style: TextStyle(fontSize: 16),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transactions',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DropdownButton<String>(
                              hint: Text('Select duration'),
                              value: transactionDuration,
                              items: [
                                DropdownMenuItem(
                                  value: '7',
                                  child: Text('7 days'),
                                ),
                                DropdownMenuItem(
                                  value: '30',
                                  child: Text('30 days'),
                                ),
                                DropdownMenuItem(
                                  value: '60',
                                  child: Text('60 days'),
                                ),
                                DropdownMenuItem(
                                  value: '90',
                                  child: Text('90 days'),
                                ),
                                DropdownMenuItem(
                                  value: '420',
                                  child: Text('420 days'),
                                ),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  transactionDuration = newValue;
                                });
                                days = int.parse(newValue!);
                                getTransactions(accessToken, days);
                              },
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                            height: 300,
                            child: Scrollbar(
                              child: ListView.builder(
                                itemCount: _transactions.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title:
                                                  Text('Transaction Details'),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: [
                                                    Text(
                                                        'Name: ${_transactions[index]['name']}'),
                                                    Text(
                                                        'Amount: \$${_transactions[index]['amount']}'),
                                                    Text(
                                                        'Date: ${_transactions[index]['date']}'),
                                                    Text(
                                                        'Category: ${_transactions[index]['category'].join(' > ')}'),
                                                    Text(
                                                        'Merchant Name: ${_transactions[index]['merchant_name']}'),
                                                    Text(
                                                        'Authorized Date: ${_transactions[index]['authorized_date']}'),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Close'),
                                                ),
                                              ],
                                            )),
                                    child: ListTile(
                                      title: Text(_transactions[index]['name']),
                                      subtitle: Text(
                                          'Date: ${_transactions[index]['date']}'),
                                      trailing: Text(
                                          '\$${_transactions[index]['amount']}'),
                                    ),
                                  );
                                },
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> getTransactions(String accessToken, int days) async {
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
      final transactionsList = json.decode(response.body);
      setState(() {
        _transactions = transactionsList['transactions'];
      });
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }
}

// class TransactionList extends StatefulWidget {
//
//   TransactionList();
//
//   @override
//   _TransactionListState createState() => _TransactionListState();
// }
//
// Future<Map<String, dynamic>> data = PlaidApiService().fetchAccountDetailsAndTransactions(accessToken);
//
// class _TransactionListState extends State<TransactionList> {
//   Map<String, int> categoryCounts = {};
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<Map<String, dynamic>>(
//         future:
//           data ,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             List<dynamic> accounts = snapshot.data!['accounts'];
//             List<dynamic> transactions = snapshot.data!['transactions'];
//
//             return Column(
//               children: [
//                 SizedBox(height: 10),
//                 Container(
//                   height: 100,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: accounts.length,
//                     itemBuilder: (context, index) {
//                       return InkWell(
//                       onTap: () {
//                         Navigator.push(context, PageTransition(
//                             type: PageTransitionType.rightToLeftWithFade,
//                             duration: Duration(milliseconds: 300),
//                             reverseDuration: Duration(milliseconds: 300),
//                             child: detailedAccount(account: accounts[index],)));
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 0),
//                         child: Card(
//                           child: SizedBox(
//                             width: 400,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text('Account Name: ${accounts[index]['name']}',),
//
//                                   Text('Available Balance: ${accounts[index]['balances']['available']}'),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Divider(
//                   height: 1,
//                   thickness: 1,
//                   endIndent: 45,
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: transactions.length,
//                     itemBuilder: (context, index) {
//                       return InkWell(
//                         onTap: () {
//                           PlaidApiService().printCountCategory();
//                           Navigator.push(context, PageTransition(
//                               type: PageTransitionType.rightToLeftWithFade,
//                               duration: Duration(milliseconds: 300),
//                               reverseDuration: Duration(milliseconds: 300),
//                               child: detailedTransactions(transaction: transactions[index],)));
//                         },
//                         child: ListTile(
//                           title: Text(transactions[index]['name']),
//                           subtitle: Text('Date: ${transactions[index]['date']}'),
//                           trailing: Text('\$${transactions[index]['amount']}'),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
//
//
// }
