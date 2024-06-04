import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/Screen/starting_screen/login.dart';
import 'package:project/data/server_url.dart';
import 'dart:convert';
import 'package:project/layout/starting_layout.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isVerificationVisible = true;
  bool isVerified = false;
  bool isAlert = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordController2 = TextEditingController();
  TextEditingController _emaileController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _handicapController = TextEditingController();
  TextEditingController _EmailConfirmController = TextEditingController();

  @override
  void dispose() {
    _handicapController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;
    double leftCol = phoneWidth > phoneHeight ? phoneWidth * 0.05 : phoneWidth * 0.16;
    double rightCol = phoneWidth > phoneHeight ? phoneWidth * 0.24 : phoneWidth * 0.64;
    double centerMargin = 6.0;
    double lineHeight = phoneHeight * 0.06;
    double marginHeight = phoneHeight * 0.02;

    return StartingLayout(
      startBody: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(
                left: phoneWidth * 0.01, right: phoneWidth * 0.015, bottom: marginHeight * 0.5, top: marginHeight),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: phoneHeight * 0.12,
                  child: Center(
                    child: Text(
                      'Do! 당구당!',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'godo',
                        fontSize: phoneHeight * 0.05,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: lineHeight,
                  child: Row(
                    children: [
                      SizedBox(
                        width: leftCol,
                        child: const Text(
                          '*ID',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: centerMargin,
                      ),
                      SizedBox(
                        width: rightCol,
                        child: TextField(
                          maxLength: 15,
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'ID',
                            border: OutlineInputBorder(),
                            counterText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: marginHeight),
                SizedBox(
                  height: lineHeight,
                  child: Row(
                    children: [
                      SizedBox(
                        width: leftCol,
                        child: const Text(
                          '*비밀번호',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: centerMargin,
                      ),
                      SizedBox(
                        width: rightCol,
                        child: TextField(
                          maxLength: 16,
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: '비밀번호 입력',
                            border: OutlineInputBorder(),
                            counterText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: marginHeight),
                SizedBox(
                  height: lineHeight,
                  child: Row(
                    children: [
                      SizedBox(
                        width: leftCol,
                        child: const Text(
                          '',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: centerMargin,
                      ),
                      SizedBox(
                        width: rightCol,
                        child: TextField(
                          maxLength: 15,
                          controller: _passwordController2,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: '비밀번호를 다시 입력해주세요.',
                            border: OutlineInputBorder(),
                            counterText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: marginHeight),
                SizedBox(
                  height: lineHeight,
                  child: Row(
                    children: [
                      SizedBox(
                        width: leftCol,
                        child: const Text(
                          '*Email',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: centerMargin,
                      ),
                      SizedBox(
                        width: rightCol,
                        child: TextField(
                          maxLength: 30,
                          controller: _emaileController,
                          decoration: InputDecoration(
                            counterText: '',
                            labelText: 'email@aaa.com',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  // color: borderColor,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // AnimatedContainer(
                //   duration: Duration(milliseconds: 200),
                //   height: isVerificationVisible ? 63.0 : 0.0,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       SizedBox(
                //         width: leftCol,
                //       ),
                //       Container(
                //         width: 183,
                //         padding: EdgeInsets.symmetric(vertical: 10),
                //         child: TextField(
                //           controller: _EmailConfirmController,
                //           decoration: InputDecoration(
                //             labelText: '인증번호 입력',
                //             border: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                 color: alertColor,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //       ElevatedButton(
                //         onPressed: () {
                //           setState(() {
                //             // isVerificationVisible = !isVerificationVisible;
                //           });
                //         },
                //         child: Text('인증'),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: marginHeight),
                SizedBox(
                  height: lineHeight,
                  child: Row(
                    children: [
                      SizedBox(
                        width: leftCol,
                        child: const Text(
                          '닉네임',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: centerMargin,
                      ),
                      SizedBox(
                        width: rightCol,
                        child: TextField(
                          maxLength: 15,
                          controller: _nicknameController,
                          decoration: const InputDecoration(
                            labelText: '닉네임',
                            border: OutlineInputBorder(),
                            counterText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: marginHeight),
                SizedBox(
                  height: lineHeight,
                  child: Row(
                    children: [
                      SizedBox(
                        width: leftCol,
                        child: const Text(
                          '핸디',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: centerMargin,
                      ),
                      SizedBox(
                        width: rightCol,
                        child: TextField(
                          maxLength: 2,
                          controller: _handicapController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: '0에서 30사이의 숫자를 입력해주세요',
                            border: OutlineInputBorder(),
                            counterText: '',
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              int number = int.tryParse(value) ?? 0;
                              if (number < 0 || number > 30) {
                                setState(() {
                                  _handicapController.value = TextEditingValue(
                                    text: '0', // 기본값으로 변경하거나 원하는 값으로 변경할 수 있음
                                    selection: TextSelection.fromPosition(
                                      TextPosition(offset: 1), // 커서를 끝으로 이동
                                    ),
                                  );
                                });
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: marginHeight * 2),
                ElevatedButton(
                  // onPressed: isVerified ? _signup : _showRequire,
                  onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 3,
                  ),
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: marginHeight,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'tium'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: marginHeight * 0.5,
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
                  style: TextStyle(color: Colors.white, fontSize: marginHeight* 1.2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _signup() async {
    final String apiUrl = '${Url.apiUrl}ekdrnwkd/registration/';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'username': _usernameController.text,
        'password1': _passwordController.text,
        'password2': _passwordController2.text,
        'email': _emaileController.text,
        'nickname': _nicknameController.text,
        'handicap': _handicapController.text,
      },
    );

    if (response.statusCode == 204) {
      // 회원가입 성공
      print('회원가입 성공');
      _showSuccess(context);
    } else {
      // 회원가입 실패
      print('회원가입 실패: ${response.body}');
      _showFailer(response.body);
    }
  }

  Future<void> _showSuccess(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('가입완료'),
          content: const Text('정상적으로 가입이 완료되었습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Login(),
                  ),
                );
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showFailer(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('가입 실패'),
          content: Text(errorMessage),
          actions: <Widget>[
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

  void _showRequire() {
    setState(() {
      isAlert = !isAlert;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('가입 실패'),
          content: const Text('이메일 인증이 필요합니다.'),
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

  Future<void> _EmailConfirm() async {
    // final String apiUrl = '${Url.apiUrl}ekdrnwkd/login/';
    final String apiUrl = '${Url.apiUrl}login/';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'email': _emaileController.text,
        'number': _EmailConfirmController.text,
      },
    );

    if (response.statusCode == 200) {
      print('인증 성공');
      setState(() {
        isVerificationVisible = !isVerificationVisible;
        isVerified = !isVerified;
      });
    } else {
      // 로그인 실패
      print('인증 실패: ${response.body}');
    }
  }
}
