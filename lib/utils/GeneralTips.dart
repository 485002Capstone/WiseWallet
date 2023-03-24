import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types

class GeneralTips extends StatelessWidget {
  const GeneralTips({super.key});

  @override
  Widget build(BuildContext context) {
    final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid == null) {
      return Center(child: Text('User not found'));
    }

    final Stream<QuerySnapshot> tipsStream =
        FirebaseFirestore.instance.collection('Tips').snapshots();
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Text(
                'Tips to save money as a broke student',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: tipsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading');
                    }

                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data?.docs[index]
                            as DocumentSnapshot<Object?>;
                        Map<String, dynamic>? data =
                            document.data() as Map<String, dynamic>?;
                        if (data == null) {
                          return const SizedBox.shrink();
                        }
                        return InkWell(
                          onTap: () async {
                            Uri url = Uri.parse(data['link']);
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(document.id),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )))
      ],
    );
  }
}
