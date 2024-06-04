import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/Screen/community/qna_new.dart';
import 'package:project/data/ball_route.dart';
import 'package:project/data/qna_manager.dart';
import 'package:project/data/server_url.dart';
import 'package:project/data/token_manger.dart';
import 'package:http/http.dart' as http;

class QnaDetailTitle extends StatefulWidget {
  final Qna qna;

  const QnaDetailTitle({required this.qna, super.key});

  @override
  State<QnaDetailTitle> createState() => _QnaDetailTitleState();

  Widget _buildBody(BuildContext context, int currentUserId) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;
    final int postAuthorId = qna.userSeq;
    // print('작성자: $postAuthorId');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          qna.title,
          style: TextStyle(
            fontSize: phoneHeight * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // FutureBuilder(future: fetchUserInfo(postAuthorId), builder: builder)
            qna.nickName != null
                ? Text('작성자: ${qna.nickName}')
                : Text('작성자: ${qna.username}'),
            Row(
              children: [
                _TimeFormat(qna: qna)
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (postAuthorId == currentUserId)
              Row(
                children: [
                  FutureBuilder<BallRoute>(
                      future: fetchRoute(qna.locaSeq),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          BallRoute ball = snapshot.data!;
                          return TextButton(
                            onPressed: () {
                              // print(qna.locaSeq);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => QnaNew(
                                    qnaId: qna.id,
                                    ball: ball,
                                    boardX: phoneWidth * 0.6,
                                  ),
                                ),
                              );
                            },
                            child: Text('수정', style: TextStyle(fontSize: phoneHeight * 0.02, color: Colors.black),),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                  Text('|', style: TextStyle(fontSize: phoneHeight * 0.02, color: Colors.black),),
                  TextButton(
                    child: Text('삭제', style: TextStyle(fontSize: phoneHeight * 0.02, color: Colors.black),),
                    onPressed: () => _onDeleteButtonPressed(context),
                  ),
                ],
              ),
              
            
          ],
        ),
      ],
    );
  }

  void _onDeleteButtonPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제 확인'),
          content: const Text('이 글을 삭제하시겠습니까?'),
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
                  Uri.parse('${Url.apiUrl}questions/question/${qna.id}/'),
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

  // Future<void> _onEditButtonPressed(BuildContext context, double boardX) async {
  //   BallRoute ball = await fetchQuiz(qna.locaSeq);
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => QnaNew(
  //         qnaId: qna.id,
  //         ball: ball,
  //         boardX: boardX,
  //       ),
  //     ),
  //   );
  // }
}

class _QnaDetailTitleState extends State<QnaDetailTitle> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: UserSeqManager.LoadSeq(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final int currentUserId = snapshot.data ?? 0;
          return widget._buildBody(context, currentUserId);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class _TimeFormat extends StatelessWidget {
  final Qna qna;

  const _TimeFormat({required this.qna, super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.02;
    DateTime creAt = qna.createdAt;
    DateTime? upAt = qna.updatedAt;
    String createdHour = creAt.hour >= 10 ? '${creAt.hour}' : '0${creAt.hour}';
    String createdMinute =
    creAt.minute >= 10 ? '${creAt.minute}' : '0${creAt.minute}';
    String? updatedHour = upAt != null
        ? upAt.hour >= 10
        ? '${upAt.hour}'
        : '0${upAt.hour}'
        : null;
    String? updatedMinute = upAt != null
        ? upAt.minute >= 10
        ? '${upAt.minute}'
        : '0${upAt.minute}'
        : null;

    return upAt == null
        ? Text(
      '${creAt.year}.${creAt.month}.${creAt.day}  ${createdHour}:${createdMinute}',
      textAlign: TextAlign.end,
      style: TextStyle(fontSize: height),
    )
        : Text(
      '${upAt?.year}.${upAt?.month}.${upAt?.day} '
          '${updatedHour}:${updatedMinute}',
      textAlign: TextAlign.end,
      style: TextStyle(fontSize: height),
    );
  }
}

