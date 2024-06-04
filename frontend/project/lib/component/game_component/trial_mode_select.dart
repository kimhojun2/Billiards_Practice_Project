import 'package:flutter/material.dart';
import 'package:project/Screen/game/game_home.dart';
import 'package:project/component/game_component/com_button.dart';
import 'package:project/component/game_component/quiz.dart';
import 'package:project/layout/mode_layout.dart';

class TrialMode extends StatelessWidget {
  final int modeNum;
  final String modeName;
  final String quizName1;
  final String quizName2;
  final String quizName3;
  final String quizName4;

  const TrialMode({
    required this.modeNum,
    required this.modeName,
    required this.quizName1,required this.quizName2,
    required this.quizName3,
    required this.quizName4,
    super.key,});

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;
    double quizLength = phoneHeight * 0.16;

    return ModeLayout(
      headItem:
      const _Head(),
      bodyRow: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(phoneHeight *0.025),
            child: Container(
              height: phoneHeight * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
                border: Border.all(color: Colors.brown, width: 5),
                image: DecorationImage(
                  image: AssetImage('asset/img/quizselect${modeNum}.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  '$modeName\n\n\n',
                  style: TextStyle(
                      fontSize: phoneHeight * 0.07, fontFamily: 'jua', color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(height: phoneHeight * 0.016,),
                 Quiz(name: quizName1, number: 4 * modeNum - 3, quizLength: quizLength,),
                 Quiz(name: quizName2, number: 4 * modeNum - 2, quizLength: quizLength,),
                 Quiz(name: quizName3, number: 4 * modeNum - 1, quizLength: quizLength,),
                 Quiz(name: quizName4, number: 4 * modeNum, quizLength: quizLength,),
              ],
            )),
      ],
      footRow: const [
        Text(''),
      ],
    );
  }
}

class _Head extends StatelessWidget {
  const _Head({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              width: phoneWidth * 0.06,
              height: phoneHeight * 0.09,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const GameHome(),
                    ),
                  );
                },
                icon: Image.asset(
                  'asset/icon/home.png',
                ),
              ),
            ),
            SizedBox(
              width: phoneWidth * 0.015,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              width: phoneWidth * 0.06,
              height: phoneHeight * 0.09,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.u_turn_left),
              ),
            ),
          ],
        ),
        const CommunityButton(),
      ],
    );
  }
}
