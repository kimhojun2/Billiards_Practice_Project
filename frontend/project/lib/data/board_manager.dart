import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project/data/server_url.dart';

Future<List<Board>> fetchBoards() async {
  final response = await http.get(Uri.parse('${Url.apiUrl}boards/boardlist/'));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    // print(response.body);
    List<Board> boards = data
        .where((item) => item != null) // null 체크 추가
        .map((item) => Board.fromJson(item))
        .toList();
    // print(boards);
    return boards;
  } else {
    throw Exception('Failed to load boards');
  }
}

Future<BoardComment> fetchBoardComments(int board_seq) async {
  final response =
  await http.get(Uri.parse('${Url.apiUrl}boards/boardlist/${board_seq}/'));
  // print('여기까진 들어옴');
  // print(response.body);
  if (response.statusCode == 200) {
    dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
    // print(data);
    BoardComment boards = BoardComment.fromJson(data);
    // print('여기까진 들어옴2');
    return boards;
  } else {
    throw Exception('Failed to load boards');
  }
}

Future<List<Board>> fetchUserBoards(int userSeqId) async {
  final List<Board> allboards = await fetchBoards();
  // 현재 사용자가 작성한 글만 필터링하고, 최근 글 5개만 선택
  final List<Board> userBoards =
      allboards.where((post) => post.userSeq == userSeqId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt))
        ..take(5);
  return userBoards;
}

class Board {
  final int id;
  final int userSeq;
  final String username;
  final String? nickName;
  final String title;
  final String content;
  final DateTime createdAt;
  // final String createdAt;
  final DateTime? updatedAt;
  // final String? updatedAt;
  final bool? isDeleted;
  // final Comments? comments;

  Board({
    required this.id,
    required this.userSeq,
    required this.username,
    required this.nickName,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    // required this.comments,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    String dateString = json['created_at'];
    // 문자열에서 '+09:00' 부분을 정규 표현식을 사용하여 제거
    dateString = dateString.replaceAll(RegExp(r'([+-]\d{2})(\d{2})$'), '');
    DateTime parsedDateTime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS").parse(dateString);
    DateTime koreanDateTime = parsedDateTime.add(Duration(hours: 9));

    if (json['updated_at'] != null) {
      String updateString = json['updated_at'];
      updateString = updateString.replaceAll(RegExp(r'([+-]\d{2})(\d{2})$'), '');
      DateTime parsedUpdateTime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS").parse(updateString);
      DateTime koreanUpdateTime = parsedUpdateTime.add(Duration(hours: 9));

      return Board(
        id: json['id'],
        userSeq: json['user_seq'],
        username: json['username'],
        nickName: json['nickname'],
        title: json['title'],
        content: json['content'],
        createdAt: koreanDateTime,
        updatedAt: koreanUpdateTime,
        isDeleted: json['is_deleted'],
        // comments: Comments.fromJson(json['comments']),
      );
    } else {
      return Board(
        id: json['id'],
        userSeq: json['user_seq'],
        username: json['username'],
        nickName: json['nickname'],
        title: json['title'],
        content: json['content'],
        createdAt: koreanDateTime,
        updatedAt: null,
        isDeleted: json['is_deleted'],
        // comments: Comments.fromJson(json['comments']),
      );
    }
  }
}

class BoardComment {
  final int id;
  final int userSeq;
  final String username;
  final String? nickName;
  final String title;
  final String content;
  final DateTime createdAt;
  // final String createdAt;
  final DateTime? updatedAt;
  // final String? updatedAt;
  final bool? isDeleted;
  final List<Comments> comments;

  BoardComment({
    required this.id,
    required this.userSeq,
    required this.username,
    required this.nickName,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.comments,
  });

  factory BoardComment.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    String dateString = json['created_at'];
    // 문자열에서 '+09:00' 부분을 정규 표현식을 사용하여 제거
    dateString = dateString.replaceAll(RegExp(r'([+-]\d{2})(\d{2})$'), '');
    DateTime parsedDateTime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS").parse(dateString);
    DateTime koreanDateTime = parsedDateTime.add(Duration(hours: 9));

    if (json['updated_at'] != null) {
      String updateString = json['updated_at'];
      updateString = updateString.replaceAll(RegExp(r'([+-]\d{2})(\d{2})$'), '');
      DateTime parsedUpdateTime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS").parse(updateString);
      DateTime koreanUpdateTime = parsedUpdateTime.add(Duration(hours: 9));

      return BoardComment(
        id: json['id'],
        userSeq: json['user_seq'],
        username: json['username'],
        nickName: json['nickname'],
        title: json['title'],
        content: json['content'],
        createdAt: koreanDateTime,
        updatedAt: koreanUpdateTime,
        isDeleted: json['is_deleted'],
        comments: List<Comments>.from(json['comments'].map((comment) => Comments.fromJson(comment))),
      );
    } else {
      return BoardComment(
        id: json['id'],
        userSeq: json['user_seq'],
        username: json['username'],
        nickName: json['nickname'],
        title: json['title'],
        content: json['content'],
        createdAt: koreanDateTime,
        updatedAt: null,
        isDeleted: json['is_deleted'],
        comments: List<Comments>.from(json['comments'].map((comment) => Comments.fromJson(comment))),
      );
    }
  }
}

class Comments {
  final int id;
  final String username;
  final String? nickName;
  final String content;
  final String createdAt;
  final String? updatedAt;
  final bool isDeleted;
  final int userSeq;
  final int boardSeq;

  Comments({
    required this.id,
    required this.username,
    required this.nickName,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.userSeq,
    required this.boardSeq,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['id'],
      username: json['username'],
      nickName: json['nickname'],
      content: json['content'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isDeleted: json['is_deleted'],
      userSeq: json['user_seq'],
      boardSeq: json['board_seq'],
    );
  }
}
