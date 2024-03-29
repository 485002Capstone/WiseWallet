// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types
import 'dart:convert';
import 'package:WiseWallet/plaidService/TransactionList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../screens/home_wallet.dart';
import '../screens/main_screen.dart';

final _db = FirebaseFirestore.instance;

const _baseUrl = 'https://sandbox.plaid.com';

class PlaidApiService {
  var userDocRef = FirebaseFirestore.instance
      .collection('accessToken')
      .doc(FirebaseAuth.instance.currentUser?.uid);

  static Future<String> getLinkToken() async {
    final response = await http.post(
      Uri.parse('https://sandbox.plaid.com/link/token/create'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'client_id': dotenv.env['PLAID_CLIENT_ID'],
        'secret': dotenv.env['PLAID_SECRET'],
        'client_name': 'Wise Wallet',
        'country_codes': ['US'],
        'language': 'ro',
        'user': {'client_user_id': 'User ID'},
        'products': ['auth', 'transactions'],
      }),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final linkToken = responseBody['link_token'];
      return linkToken;
    } else {
      throw Exception('Failed to get link token');
    }
  }

  static Future<void>? getAccessToken(String publicToken) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/item/public_token/exchange'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'client_id': dotenv.env['PLAID_CLIENT_ID'],
        'secret': dotenv.env['PLAID_SECRET'],
        'public_token': publicToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var userDocRef = FirebaseFirestore.instance
          .collection('accessToken')
          .doc(FirebaseAuth.instance.currentUser?.uid);
      var doc = await userDocRef.get();

        if (!doc.exists) {
          return _db
              .collection("accessToken")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .set({
            "AccessToken": data['access_token'],
          });

      }
    } else {
      throw Exception('Failed to exchange public token');
    }}


  static Future<List<dynamic>> getTransactions(
      String accessToken, int days) async {
    final startDate = DateTime.now()
        .subtract(Duration(days: days))
        .toIso8601String()
        .substring(0, 10);
    final endDate = DateTime.now().toIso8601String().substring(0, 10);

    final response = await http.post(
      Uri.parse('$_baseUrl/transactions/get'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'client_id': dotenv.env['PLAID_CLIENT_ID'],
        'secret': dotenv.env['PLAID_SECRET'],
        'access_token': accessToken,
        'start_date': startDate,
        'end_date': endDate,
      }),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['transactions'];
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }


  Future<Map<String, dynamic>> fetchIncomeData(String accessToken) async {
    const url = '$_baseUrl/credit/payroll_income/get';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'client_id': dotenv.env['PLAID_CLIENT_ID'],
        'secret': dotenv.env['PLAID_SECRET'],
        'access_token': accessToken,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load income data');
    }
  }


  Future<void> syncTransactions() async {

    final response = await http.post(
        Uri.parse('$_baseUrl/transactions/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'client_id': dotenv.env['PLAID_CLIENT_ID'],
          'secret': dotenv.env['PLAID_SECRET'],
          'access_token': accessToken,
        }),
    );

    if (response.statusCode == 200) {
      print('Transactions synced successfully.');
      print(response.body);
    } else {
      print('Error syncing transactions: ${response.statusCode}');
      print(response.body);
    }
  }
  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    final startDate = DateTime.now()
        .subtract(Duration(days: 250))
        .toIso8601String()
        .substring(0, 10);
    final endDate = DateTime.now().toIso8601String().substring(0, 10);
    final response = await http.post(
      Uri.parse('$_baseUrl/transactions/get'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'client_id': dotenv.env['PLAID_CLIENT_ID'],
        'secret': dotenv.env['PLAID_SECRET'],
        'access_token': accessToken,
        'start_date': startDate,
        'end_date': endDate,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final transactions =
          List<Map<String, dynamic>>.from(jsonResponse['transactions']);

      return transactions;
    } else {
      throw Exception(
          'Failed to fetch transactions. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  }

  static Future<List<dynamic>> getAccountBalances(String accessToken) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/accounts/balance/get'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'client_id': dotenv.env['PLAID_CLIENT_ID'],
        'secret': dotenv.env['PLAID_SECRET'],
        'access_token': accessToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['accounts'];
    } else {
      throw Exception('Failed to fetch account balances');
    }
  }

  // //Terminat
  // Future<void> printTransactions(String accessToken) async {
  //
  //   List<dynamic> transactions = await PlaidApiService.getTransactions(accessToken);
  //
  //   // Print the transactions
  //   for (var transaction in transactions) {
  //     print('Name: ${transaction['name']}');
  //     print('Date: ${transaction['date']}');
  //     print('Amount: \$${transaction['amount']}');
  //     print('---');
  //   }
  // }

  // Future<void> printAccountBalances(String accessToken) async {
  //
  //   List<dynamic> accounts = await PlaidApiService.getAccountBalances(accessToken);
  //
  //   for (var account in accounts) {
  //     print('Account name: ${account['name']}');
  //     print('Available balance: \$${account['balances']['available']}');
  //     print('Current balance: \$${account['balances']['current']}');
  //     print('---');
  //   }
  // }

  Future<String> getAccessTokenFromDocument() async {
    // Fetch the document
    DocumentSnapshot documentSnapshot = await userDocRef.get();
    try {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data()! as Map<String, dynamic>;
        dynamic fieldValue = data['AccessToken'];

        // Do something with the field value
        return fieldValue as String;
      } else {
        throw Exception('Error while fetching Field');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> storeAccountIds(List<String> accountIds) async {
    try {
      return _db
          .collection('bankAccountIDs')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({'accountIds': accountIds});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> fetchAccountDetailsAndTransactions(
      String accessToken) async {
    List<dynamic> accounts =
        await PlaidApiService.getAccountBalances(accessToken);
    List<dynamic> transactions =
        await PlaidApiService.getTransactions(accessToken, days);
    return {'accounts': accounts, 'transactions': transactions};
  }

  Future<void> fetchAccountHelper() async {
    data = (await fetchAccountDetailsAndTransactions(accessToken))
        as Future<Map<String, dynamic>>;
  }

  static Future<List<dynamic>> getTransactionsByAccount({
    required String accessToken,
    required String accountId,
  }) async {
    final startDate = DateTime.now()
        .subtract(const Duration(days: 700))
        .toIso8601String()
        .substring(0, 10);
    final endDate = DateTime.now().toIso8601String().substring(0, 10);

    final response = await http.post(
      Uri.parse('https://sandbox.plaid.com/transactions/get'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'client_id': dotenv.env['PLAID_CLIENT_ID'],
        'secret': dotenv.env['PLAID_SECRET'],
        'access_token': accessToken,
        'start_date': startDate,
        'end_date': endDate,
        'options': {
          'account_ids': [accountId],
        },
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> transactions = data['transactions'];
      return transactions;
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<void> printCountCategory() async {
    Map<String, dynamic> accountDetailsAndTransactions =
        await PlaidApiService().fetchAccountDetailsAndTransactions(accessToken);

    List<Map<String, dynamic>> transactions =
        accountDetailsAndTransactions['transactions']
            .cast<Map<String, dynamic>>();

    Map<String, int> categoryCounts = countCategories(transactions);

    print(categoryCounts);
  }

  Map<String, int> countCategories(List<Map<String, dynamic>> transactions) {
    Map<String, int> categoryCounts = {};

    for (var transaction in transactions) {
      List<dynamic> categoryList = transaction['category'];
      String category = categoryList.first;

      if (categoryCounts.containsKey(category)) {
        categoryCounts[category] = categoryCounts[category]! + 1;
      } else {
        categoryCounts[category] = 1;
      }
    }
    return categoryCounts;
  }

  // Future<List<CategoryAmount>> fetchCategoriesFromPlaid() async {
  //   final startDate = DateTime.now()
  //       .subtract(const Duration(days:700))
  //       .toIso8601String()
  //       .substring(0, 10);
  //   final endDate = DateTime.now().toIso8601String().substring(0, 10);
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$_baseUrl/transactions/get'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'client_id': dotenv.env['PLAID_CLIENT_ID'],
  //         'secret': dotenv.env['PLAID_SECRET'],
  //         'access_token': accessToken,
  //         'start_date': startDate,
  //         'end_date': endDate,
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       final transactions = jsonResponse['transactions'];
  //       final Map<String, double> categoryAmountMap = {};
  //
  //       for (final transaction in transactions) {
  //         final String category = transaction['category'][0];
  //         final double amount = double.tryParse(transaction['amount'].toString()) ?? 0;
  //
  //         categoryAmountMap.update(
  //           category,
  //               (existingAmount) => existingAmount + amount,
  //           ifAbsent: () => amount,
  //         );
  //       }
  //
  //       final List<CategoryAmount> categories = categoryAmountMap.entries
  //           .map((entry) => CategoryAmount(entry.key, entry.value))
  //           .toList();
  //
  //       return categories;
  //     } else {
  //       throw Exception('Failed to fetch transactions. Status code: ${response.statusCode}, Body: ${response.body}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to fetch transactions: $e');
  //   }
  // }

  Map<String, double> countSpentPerCategory(
      List<Map<String, dynamic>> transactions) {
    Map<String, double> spentPerCategory = {};

    for (var transaction in transactions) {
      List<dynamic> categoryList = transaction['category'];
      num amount = transaction['amount'] as num;
      String category = categoryList.first;

      if (spentPerCategory.containsKey(category)) {
        spentPerCategory[category] =
            spentPerCategory[category]! + amount.toDouble();
      } else {
        spentPerCategory[category] = amount.toDouble();
      }
    }
    return spentPerCategory;
  }

  Future<void> printCountSpentPerCategory() async {
    Map<String, dynamic> accountDetailsAndTransactions =
        await PlaidApiService().fetchAccountDetailsAndTransactions(accessToken);

    List<Map<String, dynamic>> transactions =
        accountDetailsAndTransactions['transactions']
            .cast<Map<String, dynamic>>();

    Map<String, double> categoryCounts = countSpentPerCategory(transactions);

    print(categoryCounts);
  }
}
