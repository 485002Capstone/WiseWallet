import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetDate;

  const CountdownTimer({super.key, required this.targetDate});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateTimeLeft() {
    timeLeft = widget.targetDate.difference(DateTime.now());
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _calculateTimeLeft();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Time left: ${timeLeft.inDays} days, ${timeLeft.inHours % 24} hours, ${timeLeft.inMinutes % 60} minutes, ${timeLeft.inSeconds % 60} seconds',
    );
  }
}
