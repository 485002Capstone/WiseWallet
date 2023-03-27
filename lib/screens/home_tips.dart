import 'package:WiseWallet/utils/GeneralTips.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/GoalsList.dart';
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types

class TipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(25),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                height: 350,
                child: Card(
                  child: GoalsList(),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(25),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                height: 350,
                child: Card(
                  child: GeneralTips(),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}

class TipsPageForm extends StatefulWidget {
  const TipsPageForm({super.key});

  @override
  _TipsPageFormState createState() => _TipsPageFormState();
}

final _formKey = GlobalKey<FormState>();
String _goalType = 'Travel';
late int? _moneySaved;
int _selectedGoalsDays = 7;
class _TipsPageFormState extends State<TipsPageForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Money spent limit'),
            validator: (value) {
              if (value != null) {
                setState(() {
                  _moneySaved = int.parse(value);
                });
              }
              return null;
            },
          ),
          SizedBox(
            height: 10,
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Select Goal Type'),
            value: _goalType,
            onChanged: (String? newValue) {
              setState(() {
                _goalType = newValue!;
              });
            },
            items: <String>['Travel', 'Food and Drinks', 'Recreation', 'Shops']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a goal type';
              }
              return null;
            },
          ),
          SizedBox(
            height: 10,
          ),
          DropdownButtonFormField<int>(
            decoration: InputDecoration(labelText: 'Days to achieve the goal'),
            value: _selectedGoalsDays,
            onChanged: (int? newValue) {
              setState(() {
                _selectedGoalsDays = newValue!;
              });
            },
            items: <int>[7, 14, 30].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value days'),
              );
            }).toList(),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children:[
          Align(
          alignment: Alignment.bottomLeft,
          child: ElevatedButton(
            onPressed: () {
            Navigator.pop(context);
            },
            child: Text('Close'),
          ),
          ),
          SizedBox(width: 20,),
          Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: () {
              try {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  addGoalsToDataBase(
                      _goalType, _moneySaved!, _selectedGoalsDays);
                  Navigator.pop(context);
                  final snackBar = SnackBar(
                    content: const Text('Your Goal was added!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Something went wrong. Try again!')));
              }
            },
            child: Text('Submit'),
          ),
          ),
        ]),
        ],
      ),
    );
    
  }
  

  Future<void> addGoalsToDataBase(
      String goalType, int moneySaved, int daysToReachTheGoal) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    CollectionReference userGoals = FirebaseFirestore.instance
        .collection('Goals')
        .doc(user.uid)
        .collection('goals');

    return userGoals
        .add({
          'goalType': goalType,
          'moneySaved': moneySaved,
          'TimeToReachGoal': daysToReachTheGoal,
          'createdAt': FieldValue.serverTimestamp(),
        })
        .then((value) => print("Goal added: ${value.id}"))
        .catchError((error) => print("Failed to add goal: $error"));
  }
}
