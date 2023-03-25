import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:page_transition/page_transition.dart';
import '../screens/home_wallet.dart';
import 'detailedAccount.dart';
import 'plaid_api_service.dart';
import 'package:http/http.dart' as http;
import 'package:WiseWallet/screens/main_screen.dart';

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types

const _baseUrl = 'https://sandbox.plaid.com';
const List<String> list = <String>['7', '30', '60', '90', '10000'];

double totalIncome = 0;
double totalExpenses = 0;
List<Map<String, dynamic>> expenseTransactions = [];
String? transactionDuration = '30';
int days = 30;

List<dynamic> transactions = [];

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key? key}) : super(key: key);

  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  List<Map<String, dynamic>> expenseTransactions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverToBoxAdapter(
          child: FutureBuilder<Map<String, dynamic>>(
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
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      duration: Duration(milliseconds: 300),
                                      reverseDuration:
                                          Duration(milliseconds: 300),
                                      child: detailedAccount(
                                        account: accounts[index],
                                      )));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                child: SizedBox(
                                    width: 350,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
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
                                      value: '10000',
                                      child: Text('420 days'),
                                    ),
                                  ],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      transactionDuration = newValue;
                                      totalExpenses = 0;
                                      totalIncome = 0;
                                    });
                                    days = int.parse(newValue!);
                                    // PlaidApiService().syncTransactions();
                                    getTransactions(accessToken, days);
                                    transactionsFuture =
                                        PlaidApiService.getTransactions(
                                            accessToken, days);
                                  },
                                )
                              ],
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                                height: 300,
                                child: Scrollbar(
                                  child: ListView.builder(
                                    itemCount: transactions.length,
                                    itemBuilder: (context, index) {
                                      final transaction = transactions[index];
                                      final amount = transaction['amount'];

                                      return InkWell(
                                        onTap: () => showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: Text(
                                                      'Transaction Details'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: [
                                                        Text(
                                                            'Name: ${transactions[index]['name']}'),
                                                        Text(
                                                            'Amount: \$${transactions[index]['amount']}'),
                                                        Text(
                                                            'Date: ${transactions[index]['date']}'),
                                                        Text(
                                                            'Category: ${transactions[index]['category'].join(' > ')}'),
                                                        Text(
                                                            'Merchant Name: ${transactions[index]['merchant_name']}'),
                                                        Text(
                                                            'Authorized Date: ${transactions[index]['authorized_date']}'),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Close'),
                                                    ),
                                                  ],
                                                )),
                                        child: Card(
                                            child: Column(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                transaction['name'],
                                              ),
                                              trailing: Text(
                                                amount < 0
                                                    ? '+\$${amount.abs().toString()}'
                                                    : '\$${amount.abs().toString()}',
                                                style: TextStyle(
                                                  color: amount < 0
                                                      ? Colors.green
                                                      : Colors.black,
                                                ),
                                              ),
                                              subtitle: Text(
                                                  'Date: ${transactions[index]['date']}'),
                                            ),
                                          ],
                                        )),
                                      );
                                    },
                                  ),
                                )),
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
                              (totalIncome ?? 0).toStringAsFixed(2),
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                            child: Card(
                          child: ListTile(
                            title: Text('Income'),
                            subtitle: Text(
                              (totalExpenses ?? 0).toStringAsFixed(2),
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
                );
              }
            },
          ),
        )
      ],
    );
  }

  Widget buildCard(String title, double? amount, Color color) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          (amount ?? 0).toStringAsFixed(2),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
      final transactionsList = json.decode(response.body);
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
