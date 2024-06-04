import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/Screen/starting_screen/signup.dart';
import 'package:project/data/device_manger.dart';
import 'package:project/layout/starting_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:project/data/token_manger.dart';
import 'package:project/data/server_url.dart';

class LoginBack extends StatefulWidget {
  const LoginBack({super.key});

  @override
  State<LoginBack> createState() => _LoginBackState();
}

class _LoginBackState extends State<LoginBack> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return StartingLayout(
      startBody: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: phoneWidth * 0.02, vertical: phoneHeight * 0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: phoneHeight * 0.02,
                ),
                Text(
                  'Do! 당구당!',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'godo',
                    fontSize: phoneHeight * 0.06,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: phoneHeight * 0.02,
                ),
                const Divider(),
                SizedBox(
                  height: phoneHeight * 0.02,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: phoneWidth > phoneHeight ? phoneWidth * 0.05 : phoneWidth * 0.14,
                      child: Column(
                        children: [
                          SizedBox(
                            height: phoneHeight * 0.06,
                            child: Center(child: Text('ID')),
                          ),
                          SizedBox(height: phoneHeight * 0.02),
                          SizedBox(
                            height: phoneHeight * 0.06,
                            child: Center(child: Text('비밀번호')),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: phoneWidth > phoneHeight ? phoneWidth * 0.21 : phoneWidth * 0.6,
                      child: Column(
                        children: [
                          SizedBox(
                            height: phoneHeight * 0.06,
                            child: TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: '',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: phoneHeight * 0.02),
                          SizedBox(
                            height: phoneHeight * 0.06,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: '',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              onSubmitted: (String value) {
                                _login();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: phoneHeight * 0.04,
                ),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 3,
                  ),
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: phoneHeight * 0.025,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext) => SignupScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 3,
                  ),
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: phoneHeight * 0.025,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: phoneHeight * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  '뒤로가기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: phoneHeight * 0.025,
                    fontFamily: 'godo',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    // final String apiUrl = '${Url.apiUrl}ekdrnwkd/login/';
    final String apiUrl = '${Url.apiUrl}login/';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final deviceSeq = await DeviceManager.loadDevice();

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'username': _usernameController.text,
        'password': _passwordController.text,
        'device_seq': deviceSeq,
      },
    );

    if (response.statusCode == 200) {
      // 로그인 성공
      print('로그인 성공');

      final Map<String, dynamic> data = json.decode(response.body);
      // print(response.body);
      // print(data);
      final String token = data['key'];
      final int userSeq = data['user_seq'];
      final String userId = data['username'];

      // print(token);
      // print(userSeq);
      // print(userId);

      // 토큰을 SharedPreferences에 저장
      await _saveToken(token);
      await _saveUserSeq(userSeq);
      await _saveUserId(userId);
      // final String? loadedToken = await TokenManager.loadToken();

      Navigator.of(context).pop();
    } else {
      // 로그인 실패
      print('로그인 실패: ${response.body}');
      _showFailer(context);
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);
      print('토큰이 성공적으로 저장되었습니다');
    } catch (e) {
      print('토큰 저장 중 오류 발생: $e');
    }
  }

  Future<void> _saveUserSeq(int userSeq) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_seq', userSeq.toString());
  }

  Future<void> _saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  Future<void> _showFailer(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그인 실패'),
          content: const Text('아이디 또는 비밀번호가 잘못되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}
