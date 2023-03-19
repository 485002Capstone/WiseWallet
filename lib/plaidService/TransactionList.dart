import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../screens/home_wallet.dart';
import 'detailedAccount.dart';
import 'plaid_api_service.dart';
import 'package:WiseWallet/plaidService/detailedTransactions.dart';
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types


class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});



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
      body: TransactionList(),
    );
  }


}


class TransactionList extends StatefulWidget {

  TransactionList();

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  Future<Map<String, dynamic>>? _data;

  @override
  void initState() {
    super.initState();
    _data = PlaidApiService().fetchAccountDetailsAndTransactions(accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future:
          _data ,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> accounts = snapshot.data!['accounts'];
            List<dynamic> transactions = snapshot.data!['transactions'];

            return Column(
              children: [
                SizedBox(height: 10),
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                      onTap: () {
                        Navigator.push(context, PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            duration: Duration(milliseconds: 300),
                            reverseDuration: Duration(milliseconds: 300),
                            child: detailedAccount(account: accounts[index],)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Card(
                          child: SizedBox(
                            width: 400,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Account Name: ${accounts[index]['name']}'),

                                  Text('Available Balance: ${accounts[index]['balances']['available']}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Divider(
                  height: 1,
                  thickness: 1,
                  endIndent: 45,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              duration: Duration(milliseconds: 300),
                              reverseDuration: Duration(milliseconds: 300),
                              child: detailedTransactions(transaction: transactions[index],)));
                        },
                        child: ListTile(
                          title: Text(transactions[index]['name']),
                          subtitle: Text('Date: ${transactions[index]['date']}'),
                          trailing: Text('\$${transactions[index]['amount']}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }


}



