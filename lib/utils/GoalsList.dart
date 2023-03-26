import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/home_tips.dart';
import 'GoalsTimer.dart';
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types

class GoalsList extends StatelessWidget {
  const GoalsList({super.key});

  @override
  Widget build(BuildContext context) {
    final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid == null) {
      return Center(child: Text('User not found'));
    }

    final Stream<QuerySnapshot> goalsStream = FirebaseFirestore.instance
        .collection('Goals')
        .doc(currentUserUid)
        .collection('goals')
        .snapshots();
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Text(
                'Goals',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10, top: 10),
              child: MaterialButton(
                color: Colors.orange,
                minWidth: 30,
                height: 50,
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                      title: Text('Add a new goal!'),
                      content: SizedBox(
                        height: 270,
                        width: 400,
                        child: TipsPageForm(),
                      )),
                ),
                child: Text(
                  "Add a goal!",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            )
          ],
        ),
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: goalsStream,
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
                        DateTime createdAt =
                            (data['createdAt'] as Timestamp?)?.toDate() ??
                                DateTime.now();

                        DateTime targetDate = createdAt
                            .add(Duration(days: data['TimeToReachGoal']));

                        return Card(
                          child: ListTile(
                            title: Text(
                                "${data['goalType']} - \$${data['moneySaved']}"),
                            subtitle: CountdownTimer(targetDate: targetDate),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Log out'),
                                  content: const Text(
                                      'Are you sure you want to delete this goal?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteGoal(
                                            document.id, currentUserUid);
                                        Navigator.pop(context, 'OK');
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              ),
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

  Future<void> _deleteGoal(String goalDocId, String userDocId) async {
    await FirebaseFirestore.instance
        .collection('Goals')
        .doc(userDocId)
        .collection('goals')
        .doc(goalDocId)
        .delete();
  }
}


class UpcomingGoals extends StatelessWidget {
  const UpcomingGoals({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
      future: getGoalsWithOneDayLeft(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final goals = snapshot.data;

        if (goals == null || goals.isEmpty) {
          return Card(
            child: ListTile(
              title: Text('No upcoming goals to show'),
              // Add other details if needed
            ),
          );
        }

        return ListView.builder(
          itemCount: goals.length,
          itemBuilder: (context, index) {
            final goal = goals[index].data();

            return Card(
              child: ListTile(
                title: Text('${goal['goalType']} - \$${goal['moneySaved']}'),

                // Add other details if needed
              ),
            );
          },
        );
      },
    );
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getGoalsWithOneDayLeft() async {
    final userGoalsRef = FirebaseFirestore.instance.collection('Goals').doc(FirebaseAuth.instance.currentUser?.uid).collection('goals');
    final querySnapshot = await userGoalsRef.get();
    final now = DateTime.now();
    final oneDayLeftGoals = querySnapshot.docs.where((doc) {
      final goalData = doc.data();
      final createdAt = (goalData['createdAt'] as Timestamp).toDate();
      final daysToReachGoal = goalData['TimeToReachGoal'];

      final goalEndTime = createdAt.add(Duration(days: daysToReachGoal));
      final remainingDays = goalEndTime.difference(now).inDays;

      return remainingDays <= 1;
    }).toList();

    return oneDayLeftGoals;
  }


}
