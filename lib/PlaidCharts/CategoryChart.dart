import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../plaidService/TransactionList.dart';
import '../screens/main_screen.dart';

class CategoryPieChart extends StatefulWidget {
  const CategoryPieChart({super.key});

  @override
  _CategoryTransactionCountPieChartState createState() =>
      _CategoryTransactionCountPieChartState();
}

class _CategoryTransactionCountPieChartState
    extends State<CategoryPieChart> {
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

            return SfCircularChart(
              title: ChartTitle(
                  text: 'Category Pie Chart'),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CircularSeries>[
                PieSeries<CategoryCountData, String>(
                  name: 'Count',
                  dataSource: categoryData,
                  xValueMapper: (CategoryCountData category, _) =>
                      category.category,
                  yValueMapper: (CategoryCountData category, _) =>
                      category.count,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
              ],
            );
          } else {
            return const Center(child: Text('Error while fetching data. Connect bank account or try again later'));
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  List<CategoryCountData> _buildCategoryData(List<dynamic> transactions) {
    Map<String, int> categoryCountMap = {};

    transactions.forEach((transaction) {
      final category = transaction['category'][0];

      if (categoryCountMap.containsKey(category)) {
        categoryCountMap[category] = categoryCountMap[category]! + 1;
      } else {
        categoryCountMap[category] = 1;
      }
    });

    return categoryCountMap.entries
        .map((entry) => CategoryCountData(entry.key, entry.value))
        .toList();
  }
}

class CategoryCountData {
  final String category;
  final int count;

  CategoryCountData(this.category, this.count);
}
