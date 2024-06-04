import 'package:project/data/server_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// import 'package:flutter/foundation.dart';
// class AuthNotifier extends ChangeNotifier {
//   String? _token;
//
//   String? get token => _token;
//
//   // 토큰 설정
//   void setToken(String? token) {
//     _token = token;
//     notifyListeners(); // 상태 변경 알림
//   }
//
//   // 로그아웃
//   void logout() {
//     _token = null;
//     notifyListeners(); // 상태 변경 알림
//   }
// }

class TokenManager {
  static Future<String?> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<void> logout() async {
    String? token = await loadToken();
    String? username = await UserIdManager.LoadId();

    await logoutRequest(token, username);

    await clearToken();
    await UserSeqManager.clearSeq();
    await UserIdManager.clearId();
  }

  static Future<void> logoutRequest(String? token, String? username) async {
    if (token != null) {
      try {
        await http.post(
          Uri.parse('${Url.apiUrl}logout/'),
          headers: {'Authorization': 'Token $token'},
          body: {
            'username': username,
          },
        );
      } catch (e) {
        print('Error during logout request: $e');
      }
    }
  }

  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}

class UserSeqManager {
  static Future<int?> LoadSeq() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userSeqString = prefs.getString('user_seq');
      return userSeqString != null ? int.parse(userSeqString) : null;
    } catch (e) {
      print('아이디 읽기 중 오류 발생: $e');
      return null;
    }
  }

  static Future<void> clearSeq() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_seq');
  }
}

class UserIdManager {
  static Future<String?> LoadId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_id');
    } catch (e) {
      print('아이디 읽기 중 오류 발생: $e');
      return null;
    }
  }

  static Future<void> clearId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }
}

