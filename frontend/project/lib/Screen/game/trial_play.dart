import 'package:flutter/material.dart';
import 'package:project/Screen/game/trial_answer.dart';
import 'package:project/Screen/game/trial_replay.dart';
import 'package:project/component/drawer/drawing_tool.dart';
import 'package:project/component/game_component/game_head_trial.dart';
import 'package:project/component/game_component/timer.dart';
import 'package:project/data/ball_location.dart';
import 'package:project/data/device_manger.dart';
import 'package:project/layout/play_layout.dart';
import 'package:project/style/game_button.dart';

class TrialPlay extends StatelessWidget {
  final int ballSeq;

  const TrialPlay({
    required this.ballSeq,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    // bool answerButton = false;

    return PlayLayout(
      headWidget: const TrialHead(),
      bodyWidget: _Body(
        ballSeq: ballSeq,
        boardX: phoneWidth * 0.7,
      ),
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
    double phoneHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        Expanded(
          child: Center(
            child: Container(
                width: widget.boardX,
                child: _Draw(
                  ballSeq: widget.ballSeq,
                  boardX: widget.boardX,
                )),
          ),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  String? device = await DeviceManager.loadDevice();
                  int deviceInt = int.parse(device!);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TrialReplay(
                            deviceSeq: deviceInt,
                            ballSeq: widget.ballSeq,
                          )));
                },
                style: gameButton,
                child: Text(
                  '이전경로',
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'godo', fontSize: phoneHeight * 0.042),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // _showLocation(context);
                  // Future.delayed(Duration(seconds: 5), () {
                  //   Navigator.pop(context);
                  // });
                },
                style: gameButton,
                child: Text(
                  '경로표시',
                  style: TextStyle(
                      color: Colors.grey, fontFamily: 'godo', fontSize: phoneHeight * 0.042),
                ),
              ),
              // QuestionButton(ballSeq: widget.ballSeq,),
              ElevatedButton(
                  onPressed: () {
                    _showNothingchanged(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      // side: BorderSide(color: Colors.black, width: 3)
                    ),
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 0.0),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBorder(),
                    ],
                  )),
              ElevatedButton(
                onPressed: () {
                  _showAnswer(context);
                },
                style: gameButton,
                child: Text(
                  '정답확인',
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'godo', fontSize: phoneHeight * 0.042),
                ),
              ),
              const GameTimer(),
            ],
          ),
        ),
      ],
    );
  }

  // Future<void> _showRoute(BuildContext context) async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('알림'),
  //         content: const Text('당구대에 공 경로가 표시됩니다.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // 모달 닫기
  //             },
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> _showLocation(BuildContext context) async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('알림'),
  //         content: const Text('당구대에 공 위치가 표시됩니다.\n색에 맞춰 공을 놓고 연습을 시작하세요'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // 모달 닫기
  //             },
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _showNothingchanged(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('반복 중'),
          content: const Text('공이 전부 멈춘 후 자동으로 위치를 표시합니다.'),
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

  Future<void> _showAnswer(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('정답을 확인하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // _showAnswerModal(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        TrialAnswer(ballSeq: widget.ballSeq)));
              },
              child: const Text('예'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
              child: const Text('아니오'),
            ),
          ],
        );
      },
    );
  }

  // Future<void> _showAnswerModal(BuildContext context) async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('알림'),
  //         content: Text('정답이 앱과 당구대에 표시됩니다.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               // Navigator.of(context).pop();
  //               Navigator.of(context).push(
  //                   MaterialPageRoute(builder: (context) => TrialAnswer(ballSeq: widget.ballSeq))
  //               );
  //             },
  //             child: Text('닫기'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

class _Draw extends StatefulWidget {
  final int ballSeq;
  final double boardX;

  const _Draw({
    required this.ballSeq,
    required this.boardX,
    super.key,
  });

  @override
  State<_Draw> createState() => _DrawState();
}

class _DrawState extends State<_Draw> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BallLocation>(
      future: fetchQuizLoca(widget.ballSeq),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          BallLocation ball = snapshot.data!;
          return Center(
            child: DrawingTool(
              ballPositions: ball.locaFile.positions,
              boardX: widget.boardX,
              billiardInfo: ball.locaFile.billiardInfo,
              // ballPositions: testPositions,
            ),
          );
        }
      },
    );
  }
}

class AnimatedBorder extends StatefulWidget {
  @override
  _AnimatedBorderState createState() => _AnimatedBorderState();
}

class _AnimatedBorderState extends State<AnimatedBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue.withOpacity(_animationController.value),
              width: 7.0,
            ),
            borderRadius: BorderRadius.circular(18), // 버튼의 테두리와 일치하도록 설정합니다.
          ),
          child: Text(
            '다시놓기',
            style: TextStyle(
                color: Colors.black, fontFamily: 'godo', fontSize: phoneHeight * 0.042),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
