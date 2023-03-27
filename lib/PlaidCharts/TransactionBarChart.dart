import 'package:WiseWallet/plaidService/plaid_api_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../plaidService/TransactionList.dart';
import '../screens/main_screen.dart';

class CategoryTransactionsBarChart extends StatefulWidget {
  const CategoryTransactionsBarChart({super.key});

  @override
  _CategoryTransactionsChartState createState() =>
      _CategoryTransactionsChartState();
}

class _CategoryTransactionsChartState extends State<CategoryTransactionsBarChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: transactionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final transactions = snapshot.data!;
            final categoryData = _buildCategoryData(transactions);

            return SfCartesianChart(
              isTransposed: true,
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'Transactions Bar Chart'),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <BarSeries>[
                BarSeries<CategoryData, String>(
                  name: 'Amount',
                  dataSource: categoryData,
                  xValueMapper: (CategoryData category, _) => category.category,
                  yValueMapper: (CategoryData category, _) => category.amount,
                ),
              ],
            );
          } else {
            return const Center(
                child: Text(
                    'Error while fetching data. Connect bank account or try again later'));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  List<CategoryData> _buildCategoryData(List<dynamic> transactions) {
    Map<String, double> categoryAmountMap = {};

    for (var transaction in transactions) {
      final category = transaction['category'][0];
      final amount = transaction['amount'].toDouble();

      if (categoryAmountMap.containsKey(category)) {
        if (amount > 0) {
          categoryAmountMap[category] = categoryAmountMap[category]! + amount;
        }
      } else {
        if (amount > 0) {
          categoryAmountMap[category] = amount;
        }
      }
    }

    return categoryAmountMap.entries
        .map((entry) => CategoryData(entry.key, entry.value))
        .toList();
  }
}

class CategoryData {
  final String category;
  final double amount;

  CategoryData(this.category, this.amount);
}
