import 'package:WiseWallet/plaidService/plaid_api_service.dart';
import 'package:flutter/material.dart';
import '../screens/home_wallet.dart';
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types
class detailedAccount extends StatefulWidget {
  final Map<String, dynamic> account;

  detailedAccount({required this.account});

  @override
  _DetailedAccountPageState createState() => _DetailedAccountPageState();
}

class _DetailedAccountPageState extends State<detailedAccount> {
  late Future<List<dynamic>> _transactionsFuture;

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
        title: Text('Account Details'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.account['name'],
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Available: \$${widget.account['balances']['available']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Current: \$${widget.account['balances']['current']}',
                        style: TextStyle(fontSize: 16),
                      ),
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
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(transactions[index]['name']),
                        subtitle: Text(transactions[index]['date']),
                        trailing: Text('\$${transactions[index]['amount']}'),
                        onTap: () {
                          // Navigate to the transaction details page
                        },
                      );
                    },
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
