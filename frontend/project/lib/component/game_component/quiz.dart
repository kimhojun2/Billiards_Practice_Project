import 'package:flutter/material.dart';
import 'package:project/Screen/game/trial_play.dart';
import 'package:project/component/set_device_state.dart';

class Quiz extends StatelessWidget {
  final String name;
  final int number;
  final double quizLength;

  const Quiz({
    required this.name,
    required this.number,
    required this.quizLength,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TrialPlay(ballSeq: number - 1),
          ),
        );
        SetDeviceLocation((number).toString());
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: quizLength * 0.09, vertical: quizLength * 0.045),
        height: quizLength,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.brown, width: 2),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: quizLength * 0.24, vertical: quizLength * 0.1),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: quizLength * 0.28,
                    fontFamily: 'godo',
                  ),
                ),
              ),
              SizedBox(
                width: quizLength * 1.35, // 이미지의 가로 길이
                height: quizLength * 0.8, // 이미지의 세로 길이
                child: Image.asset(
                  'asset/img/quiz$number.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
