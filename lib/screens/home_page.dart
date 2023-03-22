// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';
import '../PlaidCharts/CategoryChart.dart';
import '../PlaidCharts/CategoryLineChart.dart';
import '../PlaidCharts/TransactionBarChart.dart';
import '../PlaidCharts/TransactionsLineChart.dart';
import '../plaidService/TransactionList.dart';
import '../plaidService/plaid_api_service.dart';
import 'home_wallet.dart';
import 'package:WiseWallet/screens/main_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

late int totalCount;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    transactionsFuture = PlaidApiService.getTransactions(accessToken, days);
  }

  Widget build(BuildContext context) {
    // My Wisewallet + logo
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
        body: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CategoryTransactionCountLineChart(),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CategoryTransactionCountPieChart(),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CategoryTransactionsChart(),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CategoryTransactionsLineChart(),
                      ),
                    ),
                  ],
                ),
              ),
            ]));
  }
}
