// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';

class HomeTips extends StatelessWidget {
  const HomeTips({super.key});

  Widget build(BuildContext context) {
    // My Wisewallet + logo
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 1,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'WISEWALLET',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Image.asset('assets/images/logofinal.png',
                    width: 60, height: 50, alignment: Alignment.centerRight),
              ],
            )),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Column(children: const [
                SizedBox(height: 20),
                Text(
                  'Very tips',
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
