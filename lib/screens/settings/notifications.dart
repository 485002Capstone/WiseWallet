// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text("Notifications",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Column(children: const [
                SizedBox(height: 20),
                Text(
                  'Email@gmail.com',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                //Version Text
              ]),
            ),
          ],
        ));
  }
}
