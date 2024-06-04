import 'package:flutter/material.dart';
import 'package:project/Screen/community/qna_detail.dart';
import 'package:project/Screen/game/qna_answer.dart';
import 'package:project/component/drawer/drawing_tool.dart';
import 'package:project/component/game_component/timer.dart';
import 'package:project/data/ball_location.dart';
import 'package:project/data/device_manger.dart';
import 'package:project/data/qna_manager.dart';
import 'package:project/layout/play_layout.dart';
import 'package:project/style/game_button.dart';
import 'dart:math';

class QnaSolve extends StatelessWidget {
  final BallLocation ball;
  final Qna qna;

  const QnaSolve({
    required this.ball,
    required this.qna,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    // bool answerButton = false;

    return PlayLayout(
      headWidget: _Head(
        qna: qna,
      ),
      bodyWidget: _Body(
        ball: ball,
        boardX: phoneWidth * 0.7,
        qna: qna,
      ),
    );
  }
}

class _Head extends StatelessWidget {
  final Qna qna;

  const _Head({required this.qna, super.key});

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
                color: Colors.black, fontFamily: 'godo', fontSize: phoneHeight * 0.042),
          ),
        )
      ],
    );
  }
}

class _Body extends StatefulWidget {
  final BallLocation ball;
  final Qna qna;
  final double boardX;

  const _Body({
    required this.ball,
    required this.boardX,
    required this.qna,
    super.key,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // 애니메이션 지속시간 (1초)
      reverseDuration: const Duration(milliseconds: 1000),
    )..repeat(); // 애니메이션을 반복하도록 설정
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Container(
                width: widget.boardX,
                child: _Draw(
                  ball: widget.ball,
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
                  int devInt = int.parse(device!);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QnaAnswer(
                        qna: widget.qna,
                        deviceSeq: devInt,
                      ),
                    ),
                  );
                  // _showReply(context);
                  // Future.delayed(Duration(seconds: 5), () {
                  //   Navigator.pop(context);
                  // });
                },
                style: gameButton,
                child: Text(
                  '경로선택',
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'godo', fontSize: widget.boardX * 0.034),
                ),
              ),
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
                onPressed: () {},
                style: gameButton,
                child: Text(
                  '답글작성',
                  style: TextStyle(
                      color: Colors.grey, fontFamily: 'godo', fontSize: widget.boardX * 0.034),
                ),
              ),
              GameTimer(),
            ],
          ),
        ),
      ],
    );
  }

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

  // Future<void> _showReply(BuildContext context) async {
  //   String? deviceNum = await DeviceManager.loadDevice();
  //
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('알림'),
  //         content: const Text('경로확인 후 첨부할 답변을 선택해주세요.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               // print('솔브페이지에도 있음${widget.qna.id}');
  //               Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (context) => QnaAnswer(
  //                   qnaId: widget.qna.id,
  //                   deviceSeq: 111111,
  //                 ),
  //               ));
  //             },
  //             child: const Text('확인'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // 모달 닫기
  //             },
  //             child: const Text('취소'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

class _Draw extends StatefulWidget {
  final BallLocation ball;
  final double boardX;

  const _Draw({
    required this.ball,
    required this.boardX,
    super.key,
  });

  @override
  State<_Draw> createState() => _DrawState();
}

class _DrawState extends State<_Draw> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DrawingTool(
        ballPositions: widget.ball.locaFile.positions,
        boardX: widget.boardX,
        billiardInfo: widget.ball.locaFile.billiardInfo,
      ),
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
    double height = MediaQuery.of(context).size.height * 0.041;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: height * 0.26, horizontal: height * 0.6),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue.withOpacity(_animationController.value),
              width: height * 0.26,
            ),
            borderRadius: BorderRadius.circular(18), // 버튼의 테두리와 일치하도록 설정합니다.
          ),
          child: Text(
            '다시놓기',
            style: TextStyle(
                color: Colors.black, fontFamily: 'godo', fontSize: height,),
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
