import 'package:flutter/material.dart';
import 'package:project/Screen/game/game_home.dart';
import 'package:project/Screen/game/trial_mode.dart';
import 'package:project/component/game_component/com_button.dart';
import 'package:project/style/game_button.dart';

class TrialHead extends StatelessWidget {
  const TrialHead({super.key});

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
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const TrialHome(),
                  ),
                );
              },
              style: gameButton,
              child: Text(
                '문제선택',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'godo', fontSize: phoneHeight * 0.042),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            const CommunityButton(),
          ],
        ),
      ],
    );
  }
}