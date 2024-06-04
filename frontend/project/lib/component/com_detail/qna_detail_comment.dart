import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/Screen/game/qna_check.dart';
import 'package:project/component/drawer/drawing_tool.dart';
import 'package:project/data/ball_route.dart';
import 'package:project/data/device_manger.dart';
import 'package:project/data/qna_manager.dart';
import 'package:project/data/server_url.dart';
import 'package:project/data/token_manger.dart';
import 'package:http/http.dart' as http;

class QnaDetailComment extends StatefulWidget {
  final Qna qna;

  const QnaDetailComment({required this.qna, super.key});

  @override
  State<QnaDetailComment> createState() => _QnaDetailCommentState();
}

class _QnaDetailCommentState extends State<QnaDetailComment> {
  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: EdgeInsets.only(left: phoneWidth * 0.015, bottom: phoneHeight * 0.02),
          child: Text('답글', style: TextStyle(fontSize: phoneHeight * 0.025),),
        ),
        _Body(qna: widget.qna),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final Qna qna;

  const _Body({required this.qna, super.key});

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: phoneWidth * 0.01),
      child: FutureBuilder<QnaComment>(
        future: fetchQnaComments(qna.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            QnaComment qnas = snapshot.data!;
            return Center(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: qnas.replies.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    margin: EdgeInsets.symmetric(vertical: phoneHeight * 0.02),
                    child: ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: phoneWidth * 0.18,
                            child: FutureBuilder<BallRoute>(
                                future: fetchRoute(qnas.replies[index].routeSeq),
                                // future: fetchQuiz(0),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    final BallRoute ball = snapshot.data!;
                                    return DrawingTool(
                                        ballPositions: ball.routeFile.positions,
                                        boardX: phoneWidth * 0.18,
                                      billiardInfo: ball.routeFile.billiardInfo,
                                    );
                                  } else {
                                    return const Text('');
                                  }
                                }),
                          ),
                          SizedBox(
                            width: phoneWidth * 0.02,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  qnas.replies[index].nickName != null
                                      ? Text('${qnas.replies[index].nickName}', style: TextStyle(
                                      fontSize: phoneHeight * 0.02, color: Colors.black),)
                                      : Text('${qnas.replies[index].username}', style: TextStyle(
                                      fontSize: phoneHeight * 0.02, color: Colors.black),),
                                  // Text(
                                  //   '작성자 : ${qnas.replies[index].username}',
                                  //   style: TextStyle(
                                  //       fontSize: phoneHeight * 0.02, color: Colors.black),
                                  // ),
                                  SizedBox(
                                    width: phoneWidth * 0.02,
                                  ),
                                  FutureBuilder<int?>(
                                      future: UserSeqManager.LoadSeq(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          final int currentUserId =
                                              snapshot.data ?? 0;
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              // if (qnas.comments[index].userSeq == currentUserId)
                                              //   IconButton(
                                              //     icon: Icon(Icons.edit),
                                              //     onPressed: () {}
                                              //       // onPressed: () => _onEditButtonPressed(context),
                                              //   ),
                                              if (qnas.replies[index].userSeq ==
                                                  currentUserId)
                                                Text('|', style: TextStyle(
                                                    fontSize: phoneHeight * 0.018,
                                                    color: Colors.black),),
                                              if (qnas.replies[index].userSeq ==
                                                  currentUserId)
                                                TextButton(
                                                  child: Text(
                                                    '삭제',
                                                    style: TextStyle(
                                                        fontSize: phoneHeight * 0.018,
                                                        color: Colors.black),
                                                  ),
                                                  onPressed: () =>
                                                      _onDeleteButtonPressed(
                                                          context),
                                                ),
                                            ],
                                          );
                                        } else {
                                          return const Text('');
                                        }
                                      }),
                                ],
                              ),
                              Text(
                                qnas.replies[index].content,
                                style: TextStyle(
                                    color: Colors.black),
                              ),
                              Row(
                                children: [
                                  if (qnas.replies[index].difficulty != null) Text(
                                    ' | 난이도: ${qnas.replies[index].difficulty}',
                                    style: TextStyle(
                                        fontSize: phoneHeight * 0.018, color: Colors.black),
                                  ) else Text(''),
                                  SizedBox(width: phoneHeight * 0.018,),
                                  if (phoneWidth > phoneHeight)
                                    FutureBuilder<String?>(
                                        future: DeviceManager.loadDevice(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.data == null) {
                                              return Text('');
                                            }
                                            final int deviceSeq =
                                            int.parse(snapshot.data!);
                                            return ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) => QnaCheck(
                                                    deviceSeq: deviceSeq,
                                                    qna: qna,
                                                    routeSeq: qnas
                                                        .replies[index].routeSeq,
                                                  ),
                                                ));
                                              },
                                              child: Text(
                                                '경로확인',
                                                style:
                                                TextStyle(fontSize: phoneHeight * 0.02, color: Colors.black),
                                              ),
                                            );
                                          } else {
                                            return const Text('');
                                          }
                                        })
                                  else
                                    const Text(''),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  void _onDeleteButtonPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제 확인'),
          content: const Text('이 댓글을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                String? token = await TokenManager.loadToken();
                final response = await http.delete(
                  Uri.parse('${Url.apiUrl}boards/boardlist/${qna.id}/'),
                  headers: {
                    'Authorization': 'Token $token',
                    // 다른 필요한 헤더가 있다면 여기에 추가할 수 있습니다.
                  },
                );

                if (response.statusCode == 204) {
                  // 삭제 성공
                  Navigator.pop(context); // 다이얼로그 닫기
                  Navigator.pop(context); // 상세보기 페이지 닫기 (이전 페이지로 이동)
                } else {
                  // 삭제 실패
                  // 여기에 필요한 에러 처리를 추가할 수 있습니다.
                  print('삭제 실패. 상태 코드: ${response.statusCode}');
                }
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }
}
