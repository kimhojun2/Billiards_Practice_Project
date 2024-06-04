import 'package:flutter/material.dart';
import 'package:project/Screen/game/practice.dart';
import 'package:project/component/game_component/game_head.dart';
import 'package:project/component/game_component/timer.dart';
import 'package:project/layout/play_layout.dart';
import 'package:project/style/game_button.dart';

class PracticeFirst extends StatelessWidget {
  final int deviceSeq;

  const PracticeFirst({
    required this.deviceSeq,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;

    return PlayLayout(
      headWidget: const GameHead(),
      bodyWidget: _Body(
        deviceSeq: deviceSeq,
        boardX: phoneWidth * 0.73,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final int deviceSeq;
  final double boardX;

  const _Body({
    required this.deviceSeq,
    required this.boardX,
    super.key,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  int currentIndex = 0;

  int get getCurrentIndex => currentIndex;

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SizedBox(
              width: phoneWidth * 0.031,
              child: IconButton(
                onPressed: () {},
                icon: Image.asset('asset/icon/left_arrow.png'),
              ),
            ),
            Center(
              child: Container(
                width: widget.boardX * 0.87,
                child: AspectRatio(
                  aspectRatio: 77 / 42,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('asset/img/empty_board.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '\'최근경로\'를 눌러 공이 지나간 경로를 확인하세요.\n\n'
                        '원하는 경로에서 \'경로표시\', \'다시놓기\'를 누르면\n'
                            '당구대에 공의 위치가 표시됩니다.',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'godo',
                            fontSize: phoneHeight * 0.042),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: phoneWidth * 0.031,
              child: IconButton(
                onPressed: () {},
                icon: Image.asset('asset/icon/right_arrow.png'),
              ),
            ),
            SizedBox(
              width: phoneWidth * 0.03,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            Practice(deviceSeq: widget.deviceSeq),
                      ),
                    );
                  },
                  style: gameButton,
                  child: Text(
                    '최근경로',
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'godo', fontSize: phoneHeight * 0.042),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: gameButton,
                  child: Text(
                    '경로표시',
                    style: TextStyle(
                        color: Colors.grey, fontFamily: 'godo', fontSize: phoneHeight * 0.042),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: gameButton,
                  child: Text(
                    '다시놓기',
                    style: TextStyle(
                        color: Colors.grey, fontFamily: 'godo', fontSize: phoneHeight * 0.042
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: gameButton,
                  child: Text(
                    '질문하기',
                    style: TextStyle(
                        color: Colors.grey, fontFamily: 'godo', fontSize: phoneHeight * 0.042
                    ),
                  ),
                ),
                const GameTimer(),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
