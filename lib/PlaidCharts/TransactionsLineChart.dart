import 'package:WiseWallet/plaidService/plaid_api_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../plaidService/TransactionList.dart';
import '../screens/main_screen.dart';

class CategoryTransactionsLineChart extends StatefulWidget {
  const CategoryTransactionsLineChart({super.key});

  @override
  _CategoryTransactionsLineChartState createState() =>
      _CategoryTransactionsLineChartState();
}

class _CategoryTransactionsLineChartState
    extends State<CategoryTransactionsLineChart> {
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
              primaryXAxis: CategoryAxis(),
              title:
                  ChartTitle(text: 'Category Transactions Line Chart ${days}D'),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <LineSeries>[
                LineSeries<CategoryData, String>(
                  name: 'Amount',
                  dataSource: categoryData,
                  xValueMapper: (CategoryData category, _) => category.category,
                  yValueMapper: (CategoryData category, _) => category.amount,
                ),
              ],
            );
          } else {
            return const Center(child: Text('Error while fetching data. Connect bank account or try again later'));
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
      final amount = transaction['amount'].toDouble(); // Add .toDouble() here

      if (categoryAmountMap.containsKey(category)) {
        categoryAmountMap[category] = categoryAmountMap[category]! + amount;
      } else {
        categoryAmountMap[category] = amount;
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
