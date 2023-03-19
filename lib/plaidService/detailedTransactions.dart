import 'package:flutter/material.dart';

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types
class detailedTransactions extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const detailedTransactions({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction Name: ${transaction['name']}'),
            Text('Transaction Amount: \$${transaction['amount']}'),
            Text('Transaction Date: ${transaction['date']}'),
            Text('Transaction Category: ${transaction['category'].join(' > ')}'),
            Text('Merchant Name: ${transaction['merchant_name']}'),
            Text('Authorized Date: ${transaction['authorized_date']}'),
            // Add more transaction details here as needed
          ],
        ),
      ),
    );
  }
}
