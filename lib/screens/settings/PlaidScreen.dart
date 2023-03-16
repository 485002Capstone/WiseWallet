// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import 'package:flutter/material.dart';
// import 'package:plaid_flutter/plaid_flutter.dart';
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
//
// }
//
// class _MyAppState extends State<MyApp> {
//   LinkConfiguration? _configuration;
//   StreamSubscription<LinkEvent>? _streamEvent;
//   StreamSubscription<LinkExit>? _streamExit;
//   StreamSubscription<LinkSuccess>? _streamSuccess;
//   LinkObject? _successObject;
//   late Map<String, dynamic> _accountBalance;
//   @override
//   void initState() {
//     super.initState();
//
//     _streamEvent = PlaidLink.onEvent.listen(_onEvent);
//     _streamExit = PlaidLink.onExit.listen(_onExit);
//     _streamSuccess = PlaidLink.onSuccess.listen(_onSuccess);
//   }
//
//   @override
//   void dispose() {
//     _streamEvent?.cancel();
//     _streamExit?.cancel();
//     _streamSuccess?.cancel();
//     super.dispose();
//   }
//   Future<String> getLinkToken() async {
//     final response = await http.post(
//       Uri.parse('https://sandbox.plaid.com/link/token/create'),
//       headers: {'content-type': 'application/json'},
//       body: jsonEncode({
//         'client_id': '63d7e769601c890012a7a27c',
//         'secret': '56b852ca42be8c89ce5a9c13af21fb',
//         'client_name': 'Wise Wallet',
//         'country_codes': ['US'],
//         'language': 'en',
//         'user': {'client_user_id': 'Your User ID'},
//         'products': ['auth', 'transactions'],
//         'webhook': 'https://your.webhook.url',
//       }),
//     );
//     if (response.statusCode == 200) {
//       final responseBody = jsonDecode(response.body);
//       final linkToken = responseBody['link_token'];
//       return linkToken;
//     } else {
//       throw Exception('Failed to get link token');
//     }
//   }
//   late String linktoken2;
//
//   void linktoken() async {
//     try {
//       linktoken2 = await getLinkToken();
//
//       print('Link Token: $linktoken2');
//     } catch (e) {
//       print(e);
//     }
//   }
//
//
//   void _createLinkTokenConfiguration() {
//     setState(() {
//       _configuration = LinkTokenConfiguration(
//         token: linktoken2,
//       );
//     });
//   }
//
//
//
//
//   void _onEvent(LinkEvent event) {
//     final name = event.name;
//     final metadata = event.metadata.description();
//     print("onEvent: $name, metadata: $metadata");
//   }
//
//   void _onSuccess(LinkSuccess event) {
//     final token = event.publicToken;
//     final metadata = event.metadata.description();
//     print("onSuccess: $token, metadata: $metadata");
//     setState(() => _successObject = event);
//   }
//
//   void _onExit(LinkExit event) {
//     final metadata = event.metadata.description();
//     final error = event.error?.description();
//     print("onExit metadata: $metadata, error: $error");
//   }
//
//   static Future<String> getAccessToken(String publicToken) async {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/item/public_token/exchange'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'client_id': dotenv.env['PLAID_CLIENT_ID'],
//         'secret': dotenv.env['PLAID_SECRET'],
//         'public_token': publicToken,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data['access_token'];
//     } else {
//       throw Exception('Failed to exchange public token');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Container(
//           width: double.infinity,
//           color: Colors.grey[200],
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Expanded(
//                 child: Center(
//                   child: Text(
//                     _configuration?.toJson().toString() ?? "",
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   linktoken();
//                 },
//                 child: Text("Create Legacy Token Configuration"),
//               ),
//               SizedBox(height: 15),
//               ElevatedButton(
//                 onPressed: _createLinkTokenConfiguration,
//                 child: Text("Create Link Token Configuration"),
//               ),
//               SizedBox(height: 15),
//               ElevatedButton(
//                 onPressed: _configuration != null
//                     ? () => PlaidLink.open(configuration: _configuration!)
//                     : null,
//                 child: Text("Open"),
//               ),
//               Expanded(
//                 child: Center(
//                   child: Text(
//                     _successObject?.toJson().toString() ?? "",
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }