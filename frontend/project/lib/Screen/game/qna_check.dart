import 'package:flutter/material.dart';
import 'package:project/Screen/community/qna_detail.dart';
import 'package:project/component/drawer/drawing_tool.dart';
import 'package:project/component/set_device_state.dart';
import 'package:project/component/game_component/timer.dart';
import 'package:project/data/ball_route.dart';
import 'package:project/data/qna_manager.dart';
import 'package:project/layout/play_layout.dart';
import 'package:project/style/game_button.dart';

class QnaCheck extends StatelessWidget {
  final int deviceSeq;
  final Qna qna;
  final int routeSeq;

  const QnaCheck({
    required this.deviceSeq,
    required this.qna,
    required this.routeSeq,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double boardX = MediaQuery.of(context).size.width * 0.73;

    return PlayLayout(
      headWidget: _Head(
        qna: qna,
      ),
      bodyWidget: _Body(
        deviceSeq: deviceSeq,
        boardX: boardX,
        qna: qna,
        routeSeq: routeSeq,
      ),
    );
  }
}

class _Head extends StatelessWidget {
  final Qna qna;

  const _Head({
    required this.qna,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(''),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => QnaDetailPage(qna: qna)));
          },
          style: gameButton,
          child: Text(
            '돌아가기',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'godo',
                fontSize: phoneHeight * 0.042),
          ),
        )
      ],
    );
  }
}

class _Body extends StatefulWidget {
  final int deviceSeq;
  final double boardX;
  final Qna qna;
  final int routeSeq;

  const _Body({
    required this.deviceSeq,
    required this.boardX,
    required this.qna,
    required this.routeSeq,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: widget.boardX * 1.2,
          child: FutureBuilder<BallRoute>(
            future: fetchRoute(widget.routeSeq),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator()); // 로딩 중이면 로딩 표시
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                BallRoute ball = snapshot.data!;
                return Row(
                  children: [
                    SizedBox(
                      width: widget.boardX * 0.04,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DrawingTool(
                            ballPositions:
                            ball.routeFile.positions,
                            boardX: widget.boardX * 0.9,
                            billiardInfo: ball.routeFile.billiardInfo,
                            // ballPositions: testPositions,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 20),
                            child: _TimeFormat(creAt: ball.createdAt),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: widget.boardX * 0.04,
                    ),
                    SizedBox(
                      width: widget.boardX * 0.04,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showRoute(context);
                            // Future.delayed(Duration(seconds: 5), () {
                            //   Navigator.pop(context);
                            // });
                            SetDeviceRoute(ball.routeSeq.toString());
                          },
                          style: gameButton,
                          child: Text(
                            '경로보기',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'godo',
                                fontSize: widget.boardX * 0.032),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            SetDeviceLocation(widget.qna.locaSeq.toString());
                          },
                          style: gameButton,
                          child: Text(
                            '다시놓기',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'godo',
                                fontSize: widget.boardX * 0.032),
                          ),
                        ),
                        Text(''),
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

  Future<void> _showLocation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('당구대에 공 위치가 표시됩니다.\n색에 맞춰 공을 놓고 연습을 시작하세요'),
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

class _TimeFormat extends StatelessWidget {
  final DateTime creAt;

  const _TimeFormat({required this.creAt, super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.02;
    String createdMonth = creAt.month >= 10 ? '${creAt.month}' : '0${creAt.month}';
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