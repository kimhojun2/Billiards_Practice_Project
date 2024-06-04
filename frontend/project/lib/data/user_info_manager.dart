import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/data/server_url.dart';

Future<UserInfo> fetchUserInfo(String userId) async {
  final response = await http.get(Uri.parse('${Url.apiUrl}accounts/profile/${userId}/'));
  // print('여기까진 들어옴 ${response.body}');
  if (response.statusCode == 200) {
    // print('여기까진 들어옴2 ${response.body}');
    Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    UserInfo userInfo = UserInfo.fromJson(data);
    return userInfo;
  } else {
    throw Exception('Failed to load userinfo');
  }
}

class UserInfo {
  // final int userSeqId;
  final String id;
  final String? email;
  final String? nickname;
  final int? handicap;
  // final DateTime createdAt;
  // final String createdAt;
  // final bool isresigned;
  // final String? resignedAt;
  // final int? connectedDevice;

  UserInfo({
    // required this.userSeqId,
    required this.id,
    required this.email,
    required this.nickname,
    required this.handicap,
    // required this.createdAt,
    // required this.resignedAt,
    // required this.isresigned,
    // required this.connectedDevice,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      // userSeqId: json['user_seq_id'],
      id: json['username'],
      email: json['email'],
      nickname: json['nickname'],
      handicap: json['handicap'],
      // createdAt: json['created_at'],
      // resignedAt: json['resigned_at'],
      // isresigned: json['is_resigned'],
      // connectedDevice: json['connected_device'],
    );
  }
}