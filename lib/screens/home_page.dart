// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types

import 'package:WiseWallet/screens/settings/giveusfeedback.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../PlaidCharts/CategoryChart.dart';
import '../PlaidCharts/CategoryLineChart.dart';
import '../PlaidCharts/TransactionBarChart.dart';
import '../PlaidCharts/TransactionsLineChart.dart';
import '../plaidService/TransactionList.dart';
import '../utils/GoalsList.dart';
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

  final List<_PieData> chartData = [
    _PieData('Travel', 1000, '\$1000'),
    _PieData('Shops', 1500, '\$1500'),
    _PieData('Recreation', 800, '\$800'),
    _PieData('Shops', 1200, '\$1200'),
  ];

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
            ? notConnected(context)
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          child:
                                              Text('Transactions Line Chart'),
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
                    SliverToBoxAdapter(
                        child: Card(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Upcoming Goals',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: 200, width: 400, child: UpcomingGoals())
                        ],
                      ),
                    )),
                    SliverToBoxAdapter(
                        child: Center(
                            child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Icon(
                          Icons.record_voice_over,
                          size: 60,
                        ),
                        Text(
                          'We would like to hear from you',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          'We are looking for ways to improve',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 20),
                        MaterialButton(
                          minWidth: 50,
                          height: 50,
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              side: BorderSide(
                                  width: 100, style: BorderStyle.none)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    duration: Duration(milliseconds: 300),
                                    reverseDuration:
                                        Duration(milliseconds: 300),
                                    child: feedback()));
                          },
                          child: Text(
                            "Give Us Feedback",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    )))
                  ]));
  }

  Widget homePageRecentTransactions(Map<String, dynamic> transaction) {
    final num amount = transaction['amount'];

    return Card(
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
              color: amount < 0 ? Colors.green : Colors.black,
            ),
          ),
          subtitle: Text('Date: ${transaction['date']}'),
        ),
      ],
    ));
  }

  Widget notConnected(BuildContext context) {
    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
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
                    '+\$850',
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  subtitle: Text('Date: 2023-03-14'),
                ),
              ],
            ))
          ],
        ))),
        SliverToBoxAdapter(
            child: Card(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Charts',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text('No bank account connected!'),
                ],
              ),
              dummyChart(context)
            ],
          ),
        )),
        SliverToBoxAdapter(
          child: SizedBox(
              height: 200, width: 400, child: UpcomingGoals()),
        ),
        SliverToBoxAdapter(
            child: Center(
                child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Icon(
              Icons.record_voice_over,
              size: 60,
            ),
            Text(
              'We would like to hear from you',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Text(
              'We are looking for ways to improve',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              minWidth: 50,
              height: 50,
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  side: BorderSide(width: 100, style: BorderStyle.none)),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        duration: Duration(milliseconds: 300),
                        reverseDuration: Duration(milliseconds: 300),
                        child: feedback()));
              },
              child: Text(
                "Give Us Feedback",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        )))
      ],
    );
  }

  List<Map<String, dynamic>> getRecentTransactions(
      List<dynamic> allTransactions, int count) {
    final recentTransactions =
        allTransactions.cast<Map<String, dynamic>>().take(count).toList();
    return recentTransactions;
  }

  Widget dummyChart(BuildContext context) {
    return Center(
        child: SfCircularChart(
            title: ChartTitle(text: 'Money spent by Category'),
            legend: Legend(isVisible: true),
            series: <PieSeries<_PieData, String>>[
          PieSeries<_PieData, String>(
              dataSource: chartData,
              explode: true,
              explodeIndex: 0,
              xValueMapper: (_PieData data, _) => data.xData,
              yValueMapper: (_PieData data, _) => data.yData,
              dataLabelMapper: (_PieData data, _) => data.text,
              dataLabelSettings: DataLabelSettings(isVisible: true)),
        ]));
  }
}

class _PieData {
  _PieData(
    this.xData,
    this.yData,
    this.text,
  );

  final String xData;
  final num yData;
  final String text;
}
