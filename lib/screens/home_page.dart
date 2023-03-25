// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types


import 'package:flutter/material.dart';
import '../PlaidCharts/CategoryChart.dart';
import '../PlaidCharts/CategoryLineChart.dart';
import '../PlaidCharts/TransactionBarChart.dart';
import '../PlaidCharts/TransactionsLineChart.dart';
import '../plaidService/TransactionList.dart';
import 'home_wallet.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

String chartIndex = '1';

late int totalCount;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Widget chartContent(String listIndex) {
    switch (listIndex) {
      case '1':
        return CategoryTransactionCountPieChart();
      case '2':
        return CategoryTransactionCountLineChart();
      case '3':
        return CategoryTransactionsChart();
      case '4':
        return CategoryTransactionsLineChart();
      default:
        return CategoryTransactionsLineChart();
    }
  }

  Widget build(BuildContext context) {
    final recentTransactions = getRecentTransactions(transactions, 4);
    // My Wisewallet + logo
    return Scaffold(
        body: !isConnected
        ? CircularProgressIndicator()
        : CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverToBoxAdapter(
                  child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Recent Transactions',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...recentTransactions
                        .map((transaction) =>
                            homePageRecentTransactions(transaction))
                        .toList(),
                  ],
                ),
              )),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Card(
                          child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                child: Text(
                                  'Charts',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DropdownButton<String>(
                                hint: Text('Select duration'),
                                value: chartIndex,
                                items: [
                                  DropdownMenuItem(
                                    value: '1',
                                    child: Text('Category Pie Chart'),
                                  ),
                                  DropdownMenuItem(
                                    value: '2',
                                    child: Text('Category Line Chart'),
                                  ),
                                  DropdownMenuItem(
                                    value: '3',
                                    child: Text('Transactions Bar Chart'),
                                  ),
                                  DropdownMenuItem(
                                    value: '4',
                                    child: Text('Transactions Line Chart'),
                                  ),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    chartIndex = newValue!;
                                  });
                                },
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: chartContent(chartIndex),
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ]));
  }

  Widget homePageRecentTransactions(Map<String, dynamic> transaction) {
    final num amount = transaction['amount'];

    return Card(
        child: Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.monetization_on,
            color: amount > 0 ? Colors.red : Colors.green,
          ),
          title: Text(
            transaction['name'],
            style: TextStyle(
              color: amount > 0 ? Colors.red : Colors.green,
            ),
          ),
          trailing: Text(
            '\$${amount.abs().toString()}',
            style: TextStyle(
              color: amount > 0 ? Colors.red : Colors.green,
            ),
          ),
        ),
      ],
    ));
  }

  List<Map<String, dynamic>> getRecentTransactions(
      List<dynamic> allTransactions, int count) {
    final recentTransactions =
        allTransactions.cast<Map<String, dynamic>>().take(count).toList();
    return recentTransactions;
  }
}
