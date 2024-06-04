import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GameTimer extends StatefulWidget {
  const GameTimer({super.key});

  @override
  State<GameTimer> createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  String currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    DateTime nowUtc = DateTime.now();
    DateTime now = nowUtc.add(Duration(hours: 9));

    String amPm = now.hour > 12 ? 'PM' : 'AM';
    int changedHour = now.hour > 12 ? now.hour - 12 : now.hour;

    String formattedMonth = now.month < 10 ? '0${now.month}' : '${now.month}';
    String formattedDay = now.day < 10 ? '0${now.day}' : '${now.day}';
    String formattedHour = now.hour < 10 ? '0$changedHour' : '$changedHour';
    String formattedminutes = now.minute < 10 ? '0${now.minute}' : '${now.minute}';
    String formattedTime = "${now.year}.${formattedMonth}.${formattedDay}\n"
        "${formattedHour} : ${formattedminutes} ${amPm}";

    setState(() {
      currentTime = formattedTime;
    });

    // 1초마다 현재 시간 갱신
    Future.delayed(Duration(seconds: 1), _updateTime);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.023;

    return Text(
      currentTime,
      style: TextStyle(color: Colors.white, fontSize: height),
      textAlign: TextAlign.end,
    );
  }
}
