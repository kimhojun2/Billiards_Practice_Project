import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/Screen/community/board_new.dart';
import 'package:project/component/com_detail/board_detail_comment.dart';
import 'package:project/component/com_detail/board_detail_title.dart';
import 'package:project/data/board_manager.dart';
import 'package:project/data/server_url.dart';
import 'package:project/data/token_manger.dart';
import 'package:project/layout/community_layout.dart';
import 'package:http/http.dart' as http;

class BoardDetail extends StatelessWidget {
  final Board board;

  const BoardDetail({required this.board, super.key});

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;
    // return FutureBuilder<BoardComment>(
    //   future: fetchBoardComments(board.id),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
    //     } else if (snapshot.hasError) {
    //       return Text('Error: ${snapshot.error}');
    //     } else {
    //       BoardComment boards = snapshot.data!;
          return CommunityLayout(
            bodyHead: Center(
              child: Container(
                width: phoneWidth > phoneHeight ? phoneWidth * 0.70 : phoneWidth * 0.92,
                child: DetailTitle(board: board),
              ),
            ),
            bodyCol: Center(
              child: Container(
                width: phoneWidth > phoneHeight ? phoneWidth * 0.70 : phoneWidth * 0.92,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Body(board: board),
                    const SizedBox(
                      height: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('댓글'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DetailComment(board: board),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
    //     }
    //   },
    // );
  }
}

class _Body extends StatefulWidget {
  final Board board;

  const _Body({
    required this.board,
    super.key,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    final int postAuthorId = widget.board.userSeq;

    return FutureBuilder<int?>(
      future: UserSeqManager.LoadSeq(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final int currentUserId = snapshot.data ?? 0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.board.content),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  postAuthorId == currentUserId
                      ? Row(
                    children: [
                      TextButton(
                        child: const Text('수정', style: TextStyle(color: Colors.black, fontSize: 12),),
                        onPressed: () => _onEditButtonPressed(context),
                      ),
                      const Text('|', style: TextStyle(color: Colors.black, fontSize: 12),),
                      TextButton(
                        child: const Text('삭제', style: TextStyle(color: Colors.black, fontSize: 12),),
                        onPressed: () => _onDeleteButtonPressed(context),
                      ),
                    ],
                  )
                      : const Text(''),
                ],
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
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
              onPressed: () async {
                String? token = await TokenManager.loadToken();
                final response = await http.delete(
                  Uri.parse(
                      '${Url.apiUrl}boards/boardlist/${widget.board.id}/'),
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
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  void _onEditButtonPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BoardNew(postId: widget.board.id),
      ),
    );
  }
}
