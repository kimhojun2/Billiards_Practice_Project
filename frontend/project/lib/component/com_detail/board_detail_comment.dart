import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/data/board_manager.dart';
import 'package:project/data/server_url.dart';
import 'package:project/data/token_manger.dart';
import 'package:http/http.dart' as http;

class DetailComment extends StatefulWidget {
  final Board board;

  const DetailComment({required this.board, super.key});

  @override
  State<DetailComment> createState() => _DetailCommentState();
}

class _DetailCommentState extends State<DetailComment> {
  TextEditingController _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Body(board: widget.board),
        _buildReplyInput(),
      ],
    );
  }

  Widget _buildReplyInput() {
    return SizedBox(
      // height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: _replyController,
              decoration: InputDecoration(
                labelText: ' 댓글 작성',
                labelStyle: TextStyle(
                  fontSize: 12.0, // 원하는 크기로 조정
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              String? token = await TokenManager.loadToken();
              final response = await http.post(
                Uri.parse(
                    '${Url.apiUrl}boards/board/${widget.board.id}/comment/'),
                headers: {
                  'Authorization': 'Token $token',
                },
                body: {
                  'content': _replyController.text,
                },
              );

              if (response.statusCode == 201) {
                setState(() {
                  _replyController.clear();
                });
                print('댓글작성 성공');
              } else {
                print('댓글 작성 실패. 상태 코드: ${response.statusCode}');
              }
            },
            child: Text('댓글 입력', style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final Board board;

  const _Body({required this.board, super.key});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool _isReplying = false;
  TextEditingController _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BoardComment>(
      // child: FutureBuilder<List<BoardComment>>(
      future: fetchBoardComments(widget.board.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // 로딩 중이면 로딩 표시
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          BoardComment boards = snapshot.data!;
          return Center(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: boards.comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        boards.comments[index].nickName != null
                            ? Text('${boards.comments[index].nickName}')
                            : Text('${boards.comments[index].username}'),
                        FutureBuilder<int?>(
                            future: UserSeqManager.LoadSeq(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                final int currentUserId = snapshot.data ?? 0;
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (boards.comments[index].userSeq ==
                                            currentUserId)
                                          Row(
                                            children: [
                                              // TextButton(
                                              //   child: Text(
                                              //     '수정',
                                              //     style: TextStyle(
                                              //         fontSize: 10,
                                              //         color: Colors.black),
                                              //   ),
                                              //   // onPressed: () {}
                                              //   onPressed: () {
                                              //     _buildReply();
                                              //   }
                                              // ),
                                              // Text('|'),
                                              TextButton(
                                                child: Text(
                                                  '삭제',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  _onDeleteButtonPressed(context,
                                                      boards.comments[index].id);
                                                },
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                    // _buildReplyInput()
                                  ],
                                );
                              } else {
                                return Text('');
                              }
                            }),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${boards.comments[index].content}'),
                        Divider()
                      ],
                    ));
              },
            ),
          );
        }
      },
    );
  }
  void _buildReply() {
    setState(() {
      _isReplying = true; // 댓글 입력 중인 상태로 변경
    });
  }

  Widget _buildReplyInput() {
    if (_isReplying) { // 댓글 입력 중인 상태인 경우
      return SizedBox(
        height: 60,
        width: 200,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _replyController,
              decoration: InputDecoration(
                labelText: ' 댓글 작성',
                labelStyle: TextStyle(
                  fontSize: 12.0, // 원하는 크기로 조정
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // 댓글 입력 처리 코드
              },
              child: Text('댓글 입력', style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      );
    } else { // 댓글 입력 중이 아닌 상태인 경우
      return Text('');
    }
  }

  void _onDeleteButtonPressed(BuildContext context, int commentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 확인'),
          content: Text('이 댓글을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () async {
                String? token = await TokenManager.loadToken();
                final response = await http.delete(
                  Uri.parse('${Url.apiUrl}boards/comments/${commentId}/'),
                  headers: {
                    'Authorization': 'Token $token',
                    // 다른 필요한 헤더가 있다면 여기에 추가할 수 있습니다.
                  },
                );

                if (response.statusCode == 204) {
                  Navigator.pop(context);
                  setState(() {});
                } else {
                  print('삭제 실패. 상태 코드: ${response.statusCode}');
                }
              },
              child: Text('삭제'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  // void _onEditButtonPressed(BuildContext context, Comments comment) {
  //   TextEditingController editController =
  //       TextEditingController(text: comment.content);
  //
  //   final RenderBox renderBox = context.findRenderObject() as RenderBox;
  //   final offset = renderBox.localToGlobal(Offset.zero);
  //
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           bottom: MediaQuery.of(context).viewInsets.bottom,
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             TextField(
  //               controller: editController,
  //               decoration: InputDecoration(labelText: '댓글 수정'),
  //             ),
  //             ElevatedButton(
  //               onPressed: () async {
  //                 Navigator.pop(context); // 모달 닫기
  //                 String? token = await TokenManager.loadToken();
  //                 final response = await http.put(
  //                   Uri.parse('${Url.apiUrl}boards/comments/${comment.id}/'),
  //                   headers: {
  //                     'Authorization': 'Token $token',
  //                   },
  //                   body: {'content': editController.text},
  //                 );
  //
  //                 if (response.statusCode == 200) {
  //                   setState(() {});
  //                 } else {
  //                   // 수정 실패
  //                   // 여기에 필요한 에러 처리를 추가할 수 있습니다.
  //                   print('수정 실패. 상태 코드: ${response.statusCode}');
  //                 }
  //               },
  //               child: Text('수정'),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
