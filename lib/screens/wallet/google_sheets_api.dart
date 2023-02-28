// ignore_for_file: prefer_const_declarations

import 'package:gsheets/gsheets.dart';

class GoogleSheetsAPI {
  static const _credentials = r'''
  {
    "type": "service_account",
    "project_id": "flutter-gsheets-379116",
    "private_key_id": "74a3dde53f85ada5e92e6e4d3a207f7e083e0d0a",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCrNxpxHsV6fUPT\nkZoUG92OIAQkgqnJs4RSpMfM+tpXluTUXtae4SE5jX3Fxwo+sn9nwCn9Jf+BxkHX\njmy65+cIS/BxZoKKNlJM4mMWYpz+jdVtaQjSB0U397Pq96rYFfDUMnDs4MfIvRFX\nA+IKpeBsmUjoIsm2f8/tvn/3S6MTGLafAy8ulyearN4o4BUlTPL5W4K52uY2iIhR\n4CPp+SQDr9RZDY2zw06mLjhwgY5C+q+xdVwbJihGbOD3UnbBnzNTizLmbo6VSyRa\nS7pWNRlEZ34+29+XX9qcyKVH+B8YN9m2GIWHMh9jQ+s3uKZ3XsSypTt8Pr06o/Eg\nGUhZDAXJAgMBAAECggEAEzNXQkdOoxloIVJLQqULWBRsEoIas1Vv6eqzw1+AW+E+\noThPfjrGBJPC/op/Mh/HXOW2b76ypCWNHbTJqb428P2/JaB21DQaT6f1r714WK2k\nOSRVymPpVcjwAtIqdRgkzU8ozc+5Z+AYETeMwl/uxo78F5hLIa28ri82X4+6Znoo\njfZrOxpTINpFz9AjaF216qI5mcPvJtuRHUr1sN5MFeLGzWMfsmDHkCMS78VVNEOW\nFd/yUiD9LWDfMqDYDmXxmRo3Isz6ikq1NZt5Cy/3R/euQc4yJ2ItwCa9+8/443FJ\nolA/sa2qkjW9VC142egeWjj7PAiUIbT3dmXrRu2OwQKBgQDVAMowXrOps2EFJY4R\n7btBivxZpNUUszkqrgdagfS5OY7/7+ML1Y3Tj89EyWNNBCIIN8s3FvOyGFWQXnKH\n8/bugd61i1ReqDSiyYOWCVm5FjaawPFZy0B3I/UCGLoNPR6MyanNxp1HOVk4YtgP\nz8ScDCJQlc8wrmfkkSIoIDM6sQKBgQDNxt9zwsFC0l2SVdKJO/QwYgTMHXNwRLVx\nXCjMDz9fVz0bZLFSoqWA6EP9L1INJoF92h05RMzc0WsDopvhqcM6qe/HAhoNrTJj\nqyBHmODLEM+uaG0cQLHajVfbLPHvz2yDHn2XRhBMfZK6bYlrbpmlCsgu3/aj7YAW\niulX9YWSmQKBgQDM5bSZsQ+9CAwlSkoPHxQJ6av0g+ZhwkIUt1Hlk6uZXjAcLWPI\nZ4bF48nrjpqSZI5kP1+hv9dvE4+DkAc2ls2MA6v8EWp4n+/6RETrWFVSAXdHiKDi\n0u1RbmpquOSIhanUns1UYGG9OQKFhjf3hdLIlbeQs3uahbr1GVO1K7x8EQKBgBd7\npY55YEK27RTBFIiyvdgzp2Z/yee6/5XTNZir+MhxlTimEhJjG04Ns4yWNN/pUAfD\nt2gMsPBWOcctbGqhS/VK5WEpnT2IUWLMaZ+iE6042uqFYkZCH8nYLXmGtIlwe2qv\nNRfpV/zSq8b4ryECeyg5hcTLrELi3KY17hEqpLapAoGAKySpkilwQM72BVKURe+Z\nZZB3/xsI4avujzMgD9sSAjiAc0ZL3NeRv1BQKk2xfmpUEpRa45W+sbPekzuQgeK2\n+OJbmamXSWxJlywy4miYz8yJYjCl9qT0kb2Wi32xhG8STjpPOK91yQU9ZVJejdLj\nzcKX8Gq0mkEBFv3IMAOidVg=\n-----END PRIVATE KEY-----\n",
    "client_email": "wisewalletgsheets@flutter-gsheets-379116.iam.gserviceaccount.com",
    "client_id": "109236469571365158305",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/wisewalletgsheets%40flutter-gsheets-379116.iam.gserviceaccount.com"
  }
  ''';
  // Create spreadsheet id
  static final _spreadsheetId = '1w_ong6oPoCddv84TlLdCJ2iVx2PBaUm27DT-HRJUxTo';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Sheet1');
    countRows();
  }

  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
