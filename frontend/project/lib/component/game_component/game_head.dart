import 'package:flutter/material.dart';
import 'package:project/Screen/game/game_home.dart';
import 'package:project/component/game_component/com_button.dart';

class GameHead extends StatelessWidget {
  const GameHead({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
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
        const CommunityButton(),
      ],
    );
  }
}
