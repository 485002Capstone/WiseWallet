
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


final messageController = TextEditingController();
final _db = FirebaseFirestore.instance;
class feedback extends StatelessWidget {
  const feedback({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
            elevation: 0,
            title: const Text("Feedback",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800
                    )),
          leading: IconButton (
            icon: Icon(Icons.arrow_back_ios_new),
            iconSize: 20.0,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
            body: SafeArea (
      child: ListView (
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              maxLines: 10,
            ),
          ),

          Container(
            padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
            child: MaterialButton(
              height: 50,
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Send feedback'),
                  content: const Text('Are you sure you want to send the feedback?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: ()   async {
                        try {
                          await sendFeedback(context);
                          messageController.clear();
                        }
                        catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("Something went wrong. Try again later!")));
                        }
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
              color: const Color.fromARGB(255, 52, 98, 239),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: const Text(
                "Submit",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const Text(
            'Version 9.20.0',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
      ]
    ),
    ),
    );

  }
}

Future sendFeedback(BuildContext context) async {
   var userDocRef = FirebaseFirestore.instance.collection('Feedback').doc(FirebaseAuth.instance.currentUser?.uid);
   var doc = await userDocRef.get();
   Navigator.pop(context, "OK");
  try {
    if(!doc.exists) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Your feedback has been sent!")));
    return _db.collection("Feedback").doc(FirebaseAuth.instance.currentUser?.uid).set(
        {
          "Time stamp": FieldValue.serverTimestamp(),
          'Message': messageController.text.trim()
    });
  } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Your previous feedback has not been read yet. Try again later")));
    }
  }
  catch (e) {
     ScaffoldMessenger.of(context)
         .showSnackBar(SnackBar(content: Text("Something went wrong. Try again later!")));
  }
}
