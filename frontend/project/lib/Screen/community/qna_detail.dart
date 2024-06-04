import 'package:flutter/material.dart';
import 'package:project/Screen/game/qna_solve.dart';
import 'package:project/component/com_detail/qna_detail_comment.dart';
import 'package:project/component/com_detail/qna_detail_title.dart';
import 'package:project/component/drawer/qna_drawing.dart';
import 'package:project/component/set_device_state.dart';
import 'package:project/data/ball_location.dart';
import 'package:project/data/qna_manager.dart';
import 'package:project/layout/community_layout.dart';

class QnaDetailPage extends StatelessWidget {
  final Qna qna;

  const QnaDetailPage({required this.qna, super.key});

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return CommunityLayout(
      bodyHead: Padding(
        padding: EdgeInsets.symmetric(horizontal: phoneWidth * 0.03, vertical: phoneWidth * 0.02),
        child: QnaDetailTitle(qna: qna),
      ),
      bodyCol: Padding(
        padding: EdgeInsets.symmetric(horizontal: phoneWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: phoneWidth * 0.02),
            SizedBox(
                width: phoneWidth > phoneHeight ? phoneWidth * 0.5 : phoneWidth * 0.75,
                child: const Text('공배치', textAlign: TextAlign.center,)),
            const SizedBox(height: 10,),
            FutureBuilder(
              future: fetchBall(qna.locaSeq),
              builder: (context, ball_snapshot) {
                if (ball_snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
                } else if (ball_snapshot.hasError) {
                  return Text('Error: ${ball_snapshot.error}');
                } else {
                  BallLocation ball = ball_snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: phoneWidth > phoneHeight ? phoneWidth * 0.5 : phoneWidth * 0.75,
                            child: QnaDrawing(
                              ballPositions: ball.locaFile.positions,
                              boardX: phoneWidth > phoneHeight ? phoneWidth * 0.5 : phoneWidth * 0.75,
                              billiardInfo: ball.locaFile.billiardInfo,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: phoneWidth * 0.02,),
                      Text(qna.content),
                      SizedBox(height: phoneWidth * 0.03,),
                      phoneWidth > phoneHeight ? Center(
                        child: ElevatedButton(
                            onPressed: () {
                              // print('디테일페이지에서는 넘어감${qna.id}');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      QnaSolve(ball: ball, qna: qna)));
                              SetDeviceLocation(qna.locaSeq.toString());
                            },
                            child: const Text('풀어보기', style: TextStyle(color: Colors.black),)),
                      ) : const Text(''),
                    ],
                  );
                }
              },
            ),
            QnaDetailComment(qna: qna),
          ],
        ),
      ),
    );
  }
}
