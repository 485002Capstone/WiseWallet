
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final _db = FirebaseFirestore.instance;

class PlaidApiService {
  static const _baseUrl = 'https://sandbox.plaid.com';
  var data;
  var userDocRef = FirebaseFirestore.instance.collection('accessToken').doc(FirebaseAuth.instance.currentUser?.uid);


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
        'webhook': 'https://your.webhook.url',
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
      var userDocRef = FirebaseFirestore.instance.collection('accessToken').doc(FirebaseAuth.instance.currentUser?.uid);
      var doc = await userDocRef.get();

      try {
        if(!doc.exists) {
          return _db.collection("accessToken").doc(FirebaseAuth.instance.currentUser?.uid).set(
              {
                "AccessToken": data['access_token'],
              });
        }
      } catch (e) {
        throw Exception(e);
      }
    } else {
      throw Exception('Failed to exchange public token');
    }
    return;
  }

  static Future<List<dynamic>> getTransactions(String accessToken) async {
    final startDate = DateTime.now().subtract(const Duration(days: 60)).toIso8601String().substring(0, 10);
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
        Map<String, dynamic> data = documentSnapshot.data()! as Map<
            String,
            dynamic>;
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
      return _db.collection('bankAccountIDs').doc(
          FirebaseAuth.instance.currentUser?.uid).set({
        'accountIds': accountIds
      });
    }catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> fetchAccountDetailsAndTransactions(String accessToken) async {
    List<dynamic> accounts = await PlaidApiService.getAccountBalances(accessToken);
    List<dynamic> transactions = await PlaidApiService.getTransactions(accessToken);
    return {'accounts': accounts, 'transactions': transactions};
  }


  static Future<List<dynamic>> getTransactionsByAccount({
    required String accessToken,
    required String accountId,
  }) async {
    final startDate = DateTime.now().subtract(const Duration(days: 200)).toIso8601String().substring(0, 10);
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
}

