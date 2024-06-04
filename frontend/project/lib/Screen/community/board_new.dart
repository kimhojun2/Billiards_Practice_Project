import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/Screen/community/board_detail.dart';
import 'package:project/data/board_manager.dart';
import 'package:project/data/server_url.dart';
import 'package:project/layout/community_layout.dart';
import 'package:project/data/token_manger.dart';

class BoardNew extends StatefulWidget {
  final int? postId;

  const BoardNew({Key? key, this.postId}) : super(key: key);

  @override
  State<BoardNew> createState() => _BoardNewState();
}

class _BoardNewState extends State<BoardNew> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 글 수정 시, 기존 데이터 불러오기
    if (widget.postId != null) {
      _fetchPostData();
    }
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return CommunityLayout(
      bodyHead: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width * 0.65 : MediaQuery.of(context).size.width * 0.92,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  top: 20,
                  bottom: 15,
                ),
                child: Text(''),
              ),
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
              Padding(
                padding: EdgeInsets.only(
                  left: phoneWidth * 0.01,
                  top: phoneHeight * 0.02,
                  bottom: phoneHeight * 0.015,
                ),
                child: Text('내용'),
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
                minLines: 8,
                maxLines: null, // Allows multiple lines
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _sendPostRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          // side: BorderSide(color: Colors.black, width: 3)
                        ),
                      ),
                      child: const Text(
                        '글 작성',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
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

  Future<void> _sendPostRequest() async {
    final String apiUrl = widget.postId != null
        ? '${Url.apiUrl}boards/boardlist/${widget.postId}/' // 수정할 글의 ID가 있을 경우 PUT 요청
        : '${Url.apiUrl}boards/boardlist/'; // 새 글 작성 시 POST 요청
    String? token = await TokenManager.loadToken();

    // print(token);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    final Map<String, String> body = {
      'title': _titleController.text,
      'content': _contentController.text,
    };

    final http.Response response = await (widget.postId != null
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

    _handlePostResponse(response);
  }

  Future<void> _handlePostResponse(http.Response response) async {
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Post created successfully');
      // print(response.body);
      final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      // print(data);
      final Board newBoard = await Board.fromJson(data);

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BoardDetail(board: newBoard))
      );
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => const BoardScreen(),
      //   ),
      // );
    } else {
      // Failed to create post
      print('Failed to create post. Status code: ${response.statusCode}');
      // print('Response body: ${response.body}');
      // Handle error accordingly
    }
  }

  Future<void> _fetchPostData() async {
    final String apiUrl = '${Url.apiUrl}boards/boardlist/${widget.postId}/';
    final http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // 글 데이터를 성공적으로 불러왔을 경우
      final Map<String, dynamic> postData = jsonDecode(response.body);

      // 불러온 데이터를 컨트롤러에 설정
      _titleController.text = postData['title'];
      _contentController.text = postData['content'];
    } else {
      // 실패 시에는 에러 처리
      print('Failed to fetch post data. Status code: ${response.statusCode}');
    }
  }
}
