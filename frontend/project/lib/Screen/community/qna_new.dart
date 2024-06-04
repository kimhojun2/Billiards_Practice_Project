import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/Screen/community/qna_detail.dart';
import 'package:project/component/drawer/qna_drawing.dart';
import 'package:project/data/ball_route.dart';
import 'package:project/data/qna_manager.dart';
import 'package:project/data/server_url.dart';
import 'package:project/layout/community_layout.dart';
import 'package:project/data/token_manger.dart';

class QnaNew extends StatefulWidget {
  final int? qnaId;
  final BallRoute ball;
  final double boardX;

  const QnaNew({
    required this.ball,
    required this.boardX,
    Key? key,
    this.qnaId,
  }) : super(key: key);

  @override
  State<QnaNew> createState() => _QnaNewState();
}

class _QnaNewState extends State<QnaNew> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 글 수정 시, 기존 데이터 불러오기
    if (widget.qnaId != null) {
      _fetchQnaData();
    }
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return CommunityLayout(
      bodyHead: Center(
        child: SizedBox(
          width: phoneWidth > 600 ? phoneWidth * 0.65 : phoneWidth * 0.92,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: phoneHeight * 0.05, bottom: phoneHeight * 0.02),
                child: widget.qnaId != null
                    ? Text(
                        '글 수정',
                        style: TextStyle(fontSize: phoneHeight * 0.03),
                      )
                    : Text(
                        '글 작성',
                        style: TextStyle(fontSize: phoneHeight * 0.03),
                      ),
              ),

            ],
          ),
        ),
      ),
      bodyCol: Center(
        child: SizedBox(
          width: phoneWidth > 600 ? phoneWidth * 0.65 : phoneWidth * 0.92,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: phoneHeight * 0.02,),
              Padding(
                padding: EdgeInsets.only(
                  left: phoneWidth * 0.01,
                  top: phoneHeight * 0.02,
                  bottom: phoneHeight * 0.015,
                ),
                child: const Text('내용'),
              ),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: '',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                minLines: 6,
                maxLines: null,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: phoneWidth * 0.01,
                  top: phoneHeight * 0.02,
                  bottom: phoneHeight * 0.015,
                ),
                child: const Text('공 배치'),
              ),
              SizedBox(
                width: widget.boardX * 0.4,
                child: _Image(ball: widget.ball, boardX: widget.boardX * 0.4),
              ),
              SizedBox(height: phoneHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: phoneWidth * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _sendQnaRequest,
                      child: const Text('글 작성'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendQnaRequest() async {
    final String apiUrl = widget.qnaId != null
        ? '${Url.apiUrl}questions/question/${widget.qnaId}/' // 수정할 글의 ID가 있을 경우 PUT 요청
        : '${Url.apiUrl}questions/create/${widget.ball.routeSeq}/'; // 새 글 작성 시 POST 요청
    String? token = await TokenManager.loadToken();

    // print(token);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    final Map<String, String> body = {
      'title': _titleController.text,
      // 'ball_seq': _ballController.text,
      'content': _contentController.text,
    };

    final http.Response response = await (widget.qnaId != null
        ? http.put(
            Uri.parse(apiUrl),
            headers: headers,
            body: jsonEncode(body),
          )
        : http.post(
            Uri.parse(apiUrl),
            headers: headers,
            body: jsonEncode(body),
          ));

    _handleQnaResponse(response);
  }

  Future<void> _handleQnaResponse(http.Response response) async {
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Qna created successfully');
      // print(response.body);
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));
      // print(data);
      final Qna newQna = await Qna.fromJson(data);

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => QnaDetailPage(qna: newQna)));
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => QnaScreen(),
      //   ),
      // );
    } else {
      // Failed to create post
      print('Failed to create qna. Status code: ${response.statusCode}');
      // print('Response body: ${response.body}');
      // Handle error accordingly
    }
  }

  Future<void> _fetchQnaData() async {
    final String apiUrl = '${Url.apiUrl}questions/question/${widget.qnaId}/';
    final http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // 글 데이터를 성공적으로 불러왔을 경우
      final Map<String, dynamic> qnaData = jsonDecode(response.body);

      // 불러온 데이터를 컨트롤러에 설정
      _titleController.text = qnaData['title'];
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
