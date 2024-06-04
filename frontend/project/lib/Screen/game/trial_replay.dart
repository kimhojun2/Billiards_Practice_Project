import 'package:flutter/material.dart';
import 'package:project/Screen/game/trial_answer.dart';
import 'package:project/Screen/game/trial_play.dart';
import 'package:project/component/drawer/drawing_tool.dart';
import 'package:project/component/game_component/game_head_trial.dart';
import 'package:project/component/set_device_state.dart';
import 'package:project/component/game_component/timer.dart';
import 'package:project/data/ball_route.dart';
import 'package:project/layout/play_layout.dart';
import 'package:project/style/game_button.dart';

class TrialReplay extends StatelessWidget {
  final int deviceSeq;
  final int ballSeq;

  const TrialReplay({
    required this.deviceSeq,
    required this.ballSeq,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double boardX = MediaQuery.of(context).size.width * 0.73;

    return PlayLayout(
      headWidget: const TrialHead(),
      bodyWidget: _Body(
        deviceSeq: deviceSeq,
        ballSeq: ballSeq,
        boardX: boardX,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final int deviceSeq;
  final int ballSeq;
  final double boardX;

  const _Body({
    required this.deviceSeq,
    required this.ballSeq,
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
    double phoneHeight = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: widget.boardX * 1.2,
          child: FutureBuilder<List<BallRoute>>(
            future: fetchRecentRoute(widget.deviceSeq),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator()); // 로딩 중이면 로딩 표시
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<BallRoute> balls = snapshot.data!;
                return Row(
                  children: [
                    SizedBox(
                      width: widget.boardX * 0.043,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            // print(currentIndex);
                            currentIndex = (currentIndex + 1) % balls.length;
                          });
                        },
                        icon: Image.asset('asset/icon/left_arrow.png'),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DrawingTool(
                            ballPositions:
                                balls[currentIndex].routeFile.positions,
                            boardX: widget.boardX * 0.9,
                            billiardInfo:
                                balls[currentIndex].routeFile.billiardInfo,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 20),
                            child: _TimeFormat(creAt: balls[currentIndex].createdAt),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: widget.boardX * 0.043,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            // print(currentIndex);
                            currentIndex = (currentIndex - 1) % balls.length;
                          });
                        },
                        icon: Image.asset('asset/icon/right_arrow.png'),
                      ),
                    ),
                    SizedBox(
                      width: widget.boardX * 0.043,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // fetchRecentRoute(widget.deviceSeq);
                            // setState(() {
                            //   currentIndex = 0;
                            // });
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => TrialReplay(
                                  deviceSeq: widget.deviceSeq,
                                  ballSeq: widget.ballSeq,
                                ),
                              ),
                            );
                          },
                          style: gameButton,
                          child: Text(
                            '최근경로',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'godo',
                                fontSize: phoneHeight * 0.042),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showRoute(context);
                            // Future.delayed(Duration(seconds: 5), () {
                            //   Navigator.pop(context);
                            // });
                            SetDeviceRoute(
                                balls[currentIndex].routeSeq.toString());
                          },
                          style: gameButton,
                          child: Text(
                            '경로표시',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'godo',
                                fontSize: phoneHeight * 0.042),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            SetDeviceLocation(widget.ballSeq.toString());
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  TrialPlay(ballSeq: widget.ballSeq),
                            ));
                            // _showLocation(context, widget.ballSeq);
                            // Future.delayed(Duration(seconds: 5), () {
                            //   Navigator.pop(context);
                            // });
                          },
                          style: gameButton,
                          child: Text(
                            '다시놓기',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'godo',
                                fontSize: phoneHeight * 0.042),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showAnswer(context);
                          },
                          style: gameButton,
                          child: Text(
                            '정답확인',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'godo',
                              fontSize: phoneHeight * 0.042,
                            ),
                          ),
                        ),
                        const GameTimer(),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
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

  // Future<void> _showLocation(BuildContext context, int ballSeq) async {
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
  //               Navigator.of(context).push(
  //                   MaterialPageRoute(builder: (context) => TrialPlay(ballSeq: ballSeq),)
  //               );
  //             },
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
}

class _TimeFormat extends StatelessWidget {
  final DateTime creAt;

  const _TimeFormat({required this.creAt, super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.02;
    String createdMonth =
        creAt.month >= 10 ? '${creAt.month}' : '0${creAt.month}';
    String createdDay = creAt.day >= 10 ? '${creAt.day}' : '0${creAt.day}';
    String createdHour = creAt.hour >= 10 ? '${creAt.hour}' : '0${creAt.hour}';
    String createdMinute =
        creAt.minute >= 10 ? '${creAt.minute}' : '0${creAt.minute}';

    return Text(
      '${creAt.year}.$createdMonth.$createdDay $createdHour:$createdMinute',
      textAlign: TextAlign.end,
      style: TextStyle(fontSize: height, color: Colors.white),
    );
  }
}
