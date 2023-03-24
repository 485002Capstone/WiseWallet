import 'package:WiseWallet/plaidService/plaid_api_service.dart';
import 'package:flutter/material.dart';
import '../screens/home_wallet.dart';

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types
late Future<List<dynamic>> _transactionsFuture;

class detailedAccount extends StatefulWidget {
  final Map<String, dynamic> account;

  detailedAccount({required this.account});

  @override
  _DetailedAccountPageState createState() => _DetailedAccountPageState();
}

class _DetailedAccountPageState extends State<detailedAccount> {
  @override
  void initState() {
    super.initState();
    _transactionsFuture = PlaidApiService.getTransactionsByAccount(
      accessToken: accessToken,
      accountId: widget.account['account_id'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Account Details',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.account['name'],
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 4),
                      Column(
                        children: [
                          Text(
                            'Available',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '\$${widget.account['balances']['available']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                      // Text(
                      //   'Current: \$${widget.account['balances']['current']}',
                      //   style: TextStyle(fontSize: 16),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<dynamic>>(
              future: _transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final transactions = snapshot.data!;
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transactions',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                              height: 350,
                              child: Scrollbar(
                                  child: ListView.builder(
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  return Card (
                                      child:
                                      ListTile(
                                        title: Text(transactions[index]['name']),
                                        subtitle: Text(transactions[index]['date']),
                                        trailing: Text(
                                            '\$${transactions[index]['amount']}'),
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
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Close'),
                                                    ),
                                                  ],
                                                )),
                                      )
                                  );
                                },
                              ))),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
