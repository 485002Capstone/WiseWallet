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
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            iconSize: 20.0,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Write your feedback...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 10,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        title: const Text(
                          'Send feedback',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                            'Are you sure you want to send the feedback?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                await sendFeedback(context);
                                messageController.clear();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Something went wrong. Try again later!")));
                              }
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 52, 98, 239),
                      padding: EdgeInsets.symmetric(
                          horizontal: 100.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    child: const Text("Submit"),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Version 9.20.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ));
  }
}

Future sendFeedback(BuildContext context) async {
  var userDocRef = FirebaseFirestore.instance
      .collection('Feedback')
      .doc(FirebaseAuth.instance.currentUser?.uid);
  var doc = await userDocRef.get();
  Navigator.pop(context, "OK");
  try {
    if (!doc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Your feedback has been sent!")));
      return _db
          .collection("Feedback")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
        "Time stamp": FieldValue.serverTimestamp(),
        'Message': messageController.text.trim()
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Your previous feedback has not been read yet. Try again later")));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong. Try again later!")));
  }
}
