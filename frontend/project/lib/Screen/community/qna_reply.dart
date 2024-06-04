import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/Screen/community/qna_detail.dart';
import 'package:project/component/drawer/drawing_tool.dart';
import 'package:project/component/drawer/qna_drawing.dart';
import 'package:project/data/ball_route.dart';
import 'package:project/data/qna_manager.dart';
import 'package:project/data/server_url.dart';
import 'package:project/layout/community_layout.dart';
import 'package:project/data/token_manger.dart';

class QnaReply extends StatefulWidget {
  final Qna qna;
  final BallRoute ball;
  final double boardX;

  const QnaReply({
    required this.ball,
    required this.boardX,
    required this.qna,
  });

  @override
  State<QnaReply> createState() => _QnaReplyState();
}

class _QnaReplyState extends State<QnaReply> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 글 수정 시, 기존 데이터 불러오기
    // if (widget.qnaId != null) {
    //   _fetchQnaData();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return CommunityLayout(
      bodyHead: Row(
        children: [
          FutureBuilder<QnaComment>(
            future: fetchQnaComments(widget.qna.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // 로딩 중이면 로딩 표시
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                QnaComment qna = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    '답글작성: ${qna.title}',
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }
            },
          ),
        ],
      ),
      bodyCol: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        const Text('질문 배치'),
                        SizedBox(
                          width: widget.boardX * 0.45,
                          child: _Image(
                              ball: widget.ball, boardX: widget.boardX * 0.45),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        const Text('내 답변'),
                        SizedBox(
                          width: widget.boardX * 0.45,
                          child: _AnswerImage(
                              ball: widget.ball, boardX: widget.boardX * 0.45),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _difficultyController,
                  decoration: const InputDecoration(
                    labelText: '난이도',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: '경로에 대한 설명을 입력해 주세요',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  minLines: 5,
                  maxLines: null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FutureBuilder(
                    future: fetchRepliedQna(widget.qna.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(''); // 로딩 중이면 로딩 표시
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final Qna qna = snapshot.data![0];
                        return ElevatedButton(
                          onPressed: () {
                            _sendQnaReplyRequest(qna);
                          },
                          child: const Text('글 작성', style: TextStyle(color: Colors.black),),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendQnaReplyRequest(Qna qna) async {
    // final String apiUrl = widget.qnaReplyId != null
    //     ? '${Url.apiUrl}questions/answers/${widget.qnaId}/${widget.qnaReplyId}/' // 수정할 글의 ID가 있을 경우 PUT 요청
    //     : '${Url.apiUrl}questions/answers/${widget.qnaId}/'; // 새 글 작성 시 POST 요청
    final String apiUrl = '${Url.apiUrl}questions/answers/${widget.qna.id}/';
    String? token = await TokenManager.loadToken();

    // print(token);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    final Map<String, dynamic> body = {
      // 'ball_seq': _ballController.text,
      'content': _contentController.text,
      'route_seq': widget.ball.routeSeq,
      'difficulty': _difficultyController.text,
    };

    // final http.Response response = await (widget.qnaReplyId != null
    //     ? http.put(
    //   Uri.parse(apiUrl),
    //   headers: headers,
    //   body: jsonEncode(body),
    // )
    //     : http.post(
    //   Uri.parse(apiUrl),
    //   headers: headers,
    //   body: jsonEncode(body),
    // ));

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    _handleQnaResponse(response, qna);
  }

  Future<void> _handleQnaResponse(http.Response response, Qna qna) async {
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Qna created successfully');
      // print(response.body);
      final Map<String, dynamic> data = json.decode(response.body);
      // print(data);
      // final Post newPost = await Post.fromJson(data);
      //
      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (context) => BoardDetail(post: newPost))
      // );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => QnaDetailPage(qna: qna),
        ),
      );
    } else {
      // Failed to create post
      print('Failed to create qna. Status code: ${response.statusCode}');
      // print('Response body: ${response.body}');
      // Handle error accordingly
    }
  }

  Future<void> _fetchQnaData() async {
    final String apiUrl = '${Url.apiUrl}qnas/qnalist/${widget.qna.id}/';
    final http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // 글 데이터를 성공적으로 불러왔을 경우
      final Map<String, dynamic> qnaData = jsonDecode(response.body);

      // 불러온 데이터를 컨트롤러에 설정
      _contentController.text = qnaData['content'];
    } else {
      // 실패 시에는 에러 처리
      print('Failed to fetch qna data. Status code: ${response.statusCode}');
    }
  }
}

class _Image extends StatefulWidget {
  final BallRoute ball;
  final double boardX;

  const _Image({
    required this.ball,
    required this.boardX,
    super.key,
  });

  @override
  State<_Image> createState() => _ImageState();
}

class _ImageState extends State<_Image> {
  @override
  Widget build(BuildContext context) {
    return QnaDrawing(
      ballPositions: widget.ball.routeFile.positions,
      boardX: widget.boardX,
      billiardInfo: widget.ball.routeFile.billiardInfo,
    );
  }
}

class _AnswerImage extends StatefulWidget {
  final BallRoute ball;
  final double boardX;

  const _AnswerImage({
    required this.ball,
    required this.boardX,
    super.key,
  });

  @override
  State<_AnswerImage> createState() => _AnswerImageState();
}

class _AnswerImageState extends State<_AnswerImage> {
  @override
  Widget build(BuildContext context) {
    return DrawingTool(
      ballPositions: widget.ball.routeFile.positions,
      boardX: widget.boardX,
      billiardInfo: widget.ball.routeFile.billiardInfo,
    );
  }
}
