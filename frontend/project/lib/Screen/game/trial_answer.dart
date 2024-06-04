import 'package:flutter/material.dart';
import 'package:project/Screen/game/trial_play.dart';
import 'package:project/Screen/game/trial_replay.dart';
import 'package:project/component/drawer/drawing_tool.dart';
import 'package:project/component/game_component/game_head_trial.dart';
import 'package:project/component/set_device_state.dart';
import 'package:project/component/game_component/timer.dart';
import 'package:project/data/ball_route.dart';
import 'package:project/layout/play_layout.dart';
import 'package:project/style/game_button.dart';

class TrialAnswer extends StatelessWidget {
  final int ballSeq;

  const TrialAnswer({
    required this.ballSeq,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double boardX = MediaQuery.of(context).size.width * 0.70;

    return PlayLayout(
      headWidget: const TrialHead(),
      bodyWidget:
        Row(
          children: [
            Expanded(
              child: Center(
                child: Container(
                    width: boardX,
                    child: _Body(ballSeq: ballSeq, boardX: boardX,)
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=> TrialReplay(deviceSeq: 1, ballSeq: ballSeq,))
                    );
                  },
                  style: gameButton,
                  child: const Text(
                    '최근경로',
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'godo', fontSize: 30),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showRoute(context);
                    SetDeviceRoute((ballSeq+1).toString());
                  },
                  style: gameButton,
                  child: const Text(
                    '경로표시',
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'godo', fontSize: 30),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    SetDeviceLocation((ballSeq+1).toString());
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TrialPlay(ballSeq: ballSeq),)
                    );
                  },
                  style: gameButton,
                  child: const Text(
                    '다시놓기',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'godo',
                        fontSize: 30),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: gameButton,
                  child: const Text(
                    '정답끄기',
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'godo', fontSize: 30),
                  ),
                ),
                const GameTimer(),
              ],
            ),
          ],
        ),

    );
  }

  Future<void> _showRoute(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('당구대에 공 경로가 표시됩니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _Body extends StatefulWidget {
  final int ballSeq;
  final double boardX;

  const _Body({
    required this.ballSeq,
    required this.boardX,
    super.key,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BallRoute>(
      future: fetchQuiz(widget.ballSeq),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          BallRoute ball = snapshot.data!;
          return Center(
            child: DrawingTool(
              ballPositions: ball.routeFile.positions,
              boardX: widget.boardX,
              billiardInfo: ball.routeFile.billiardInfo,
              // ballPositions: testPositions,
            ),
          );
        }
      },
    );
  }
}