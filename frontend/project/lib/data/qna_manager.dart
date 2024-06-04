import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project/data/server_url.dart';

Future<List<Qna>> fetchQnas() async {
  final response = await http.get(Uri.parse('${Url.apiUrl}questions/'));
  if (response.statusCode == 200) {
    // print(response.body);
    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Qna> qnaposts = data
        .where((item) => item != null)
        .map((item) => Qna.fromJson(item))
        .toList();
    return qnaposts;
  } else {
    throw Exception('Failed to load qnas');
  }
}

Future<QnaComment> fetchQnaComments(int qna_seq) async {
  final response =
  await http.get(Uri.parse('${Url.apiUrl}questions/question/${qna_seq}/'));
  // print('여기까진 들어옴');
  // print(response.body);
  if (response.statusCode == 200) {
    dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
    // print(data);
    QnaComment qnas = QnaComment.fromJson(data);
    // print('여기까진 들어옴2');
    return qnas;
  } else {
    throw Exception('Failed to load qnas');
  }
}

Future<List<Qna>> fetchUserQnas(int userSeqId) async {
  final List<Qna> allQnas = await fetchQnas();
  // 현재 사용자가 작성한 글만 필터링하고, 최근 글 5개만 선택
  final List<Qna> userQnas =
      allQnas.where((qnapost) => qnapost.userSeq == userSeqId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt))
        ..take(5);

  return userQnas;
}

Future<List<Qna>> fetchRepliedQna(int qnaSeq) async {
  final List<Qna> allQnas = await fetchQnas();
  // 현재 사용자가 작성한 글만 필터링하고, 최근 글 5개만 선택
  final List<Qna> userQnas =
  allQnas.where((qnapost) => qnapost.id == qnaSeq).toList()
    ..take(1);
  return userQnas;
}

class Qna {
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
  final int locaSeq;

  Qna({
    required this.id,
    required this.userSeq,
    required this.username,
    required this.nickName,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.locaSeq,
  });

  factory Qna.fromJson(Map<String, dynamic> json) {
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

      return Qna(
        id: json['id'],
        userSeq: json['user_seq'],
        username: json['username'],
        nickName: json['nickname'],
        title: json['title'],
        content: json['content'],
        createdAt: koreanDateTime,
        updatedAt: koreanUpdateTime,
        isDeleted: json['is_deleted'],
        locaSeq: json['location_seq'],
      );
    } else {
      return Qna(
        id: json['id'],
        userSeq: json['user_seq'],
        username: json['username'],
        nickName: json['nickname'],
        title: json['title'],
        content: json['content'],
        createdAt: koreanDateTime,
        updatedAt: null,
        isDeleted: json['is_deleted'],
        locaSeq: json['location_seq'],
      );
    }
  }
}

class QnaComment {
  final int id;
  final int userSeq;
  final String title;
  final String? nickName;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool? isDeleted;
  final int locaSeq;
  final List<QnaAnswers> replies;

  QnaComment({
    required this.id,
    required this.userSeq,
    required this.title,
    required this.nickName,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.locaSeq,
    required this.replies,
  });

  factory QnaComment.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('Invalid JSON data');
    }

    String dateString = json['created_at'];
    dateString = dateString.replaceAll(RegExp(r'([+-]\d{2})(\d{2})$'), '');
    DateTime parsedDateTime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS").parse(dateString);
    DateTime koreanDateTime = parsedDateTime.add(Duration(hours: 9));

    if (json['updated_at'] != null) {
      String updateString = json['updated_at'];
      updateString =
          updateString.replaceAll(RegExp(r'([+-]\d{2})(\d{2})$'), '');
      DateTime parsedUpdateTime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS")
          .parse(updateString);
      DateTime koreanUpdateTime = parsedUpdateTime.add(Duration(hours: 9));

      return QnaComment(
        id: json['id'],
        userSeq: json['user_seq'],
        nickName: json['nickname'],
        title: json['title'],
        content: json['content'],
        createdAt: koreanDateTime,
        updatedAt: koreanUpdateTime,
        isDeleted: json['is_deleted'],
        locaSeq: json['location_seq'],
        replies: List<QnaAnswers>.from(
            json['answers'].map((answer) => QnaAnswers.fromJson(answer))),
      );
    } else {
      return QnaComment(
        id: json['id'],
        userSeq: json['user_seq'],
        nickName: json['nickname'],
        title: json['title'],
        content: json['content'],
        createdAt: koreanDateTime,
        updatedAt: null,
        isDeleted: json['is_deleted'],
        locaSeq: json['location_seq'],
        replies: List<QnaAnswers>.from(
            json['answers'].map((answer) => QnaAnswers.fromJson(answer))),
      );
    }
  }
}

class QnaAnswers {
  final int id;
  final String username;
  final String? nickName;
  final String content;
  final String createdAt;
  final String? updatedAt;
  final bool? isDeleted;
  final int userSeq;
  final int qnaSeq;
  final int routeSeq;
  final int difficulty;

  QnaAnswers({
    required this.id,
    required this.username,
    required this.nickName,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.userSeq,
    required this.qnaSeq,
    required this.routeSeq,
    required this.difficulty,
  });

  factory QnaAnswers.fromJson(Map<String, dynamic> json) {
    return QnaAnswers(
      id: json['id'],
      username: json['username'],
      nickName: json['nickname'],
      content: json['content'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isDeleted: json['is_deleted'],
      userSeq: json['user_seq'],
      qnaSeq: json['question_seq'],
      routeSeq: json['route_seq'],
      difficulty: json['difficulty'],
    );
  }
}
