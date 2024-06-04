import 'package:flutter/material.dart';
import 'package:project/Screen/community/community_home.dart';
import 'package:project/Screen/community/qna_new.dart';
import 'package:project/Screen/game/game_home.dart';
import 'package:project/Screen/starting_screen/login_back.dart';
import 'package:project/component/set_device_state.dart';
import 'package:project/data/ball_route.dart';
import 'package:project/data/token_manger.dart';
import 'package:project/style/game_button.dart';

class CommunityButton extends StatelessWidget {
  const CommunityButton({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: TokenManager.loadToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로딩 중이면 프로그레스 바를 표시하거나 다른 로딩 화면을 만들 수 있습니다.
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // 에러가 발생하면 에러 메시지를 표시할 수 있습니다.
          return Text('Error loading token: ${snapshot.error}');
        } else {
          // print(snapshot.data);
          if (snapshot.data != null) {
            return Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showLogout(context);
                  },
                  style: gameButton,
                  child: Text(
                    '사용종료',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'godo',
                      fontSize: phoneHeight * 0.042,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CommunityHome(),
                      ),
                    );
                  },
                  style: gameButton,
                  child: Text(
                    '커뮤니티',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'godo',
                        fontSize: phoneHeight * 0.042),
                  ),
                ),
              ],
            );
          } else {
            return ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginBack(),
                  ),
                );
              },
              style: gameButton,
              child: Text(
                '로그인',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'godo',
                  fontSize: phoneHeight * 0.042,
                ),
              ),
            );
          }
        }
      },
    );
  }

  Future<void> _showLogout(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('사용을 종료하고 로그아웃 합니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                SetDeviceState('-1');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const GameHome(),
                  ),
                );
                TokenManager.logout();
              },
              child: const Text('확인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }
}

class QuestionButton extends StatelessWidget {
  final BallRoute ball;

  const QuestionButton({
    required this.ball,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;

    return  ElevatedButton(
      onPressed: () {
        _showQuestion(context);
      },
      style: gameButton,
      child: Text(
        '질문하기',
        style: TextStyle(
            color: Colors.black, fontFamily: 'godo', fontSize: phoneHeight * 0.042),
      ),
    );
    //   FutureBuilder(
    //   future: TokenManager.loadToken(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       // 로딩 중이면 프로그레스 바를 표시하거나 다른 로딩 화면을 만들 수 있습니다.
    //       return const CircularProgressIndicator();
    //     } else if (snapshot.hasError) {
    //       // 에러가 발생하면 에러 메시지를 표시할 수 있습니다.
    //       return Text('Error loading token: ${snapshot.error}');
    //     } else {
    //       // print(snapshot.data);
    //       if (snapshot.data != null) {
    //         return ElevatedButton(
    //           onPressed: () {
    //             _showQuestion(context);
    //           },
    //           style: gameButton,
    //           child: Text(
    //             '질문하기',
    //             style: TextStyle(
    //                 color: Colors.black, fontFamily: 'godo', fontSize: phoneHeight * 0.042),
    //           ),
    //         );
    //       } else {
    //         return ElevatedButton(
    //           onPressed: () {
    //             _showLogin(context);
    //           },
    //           style: gameButton,
    //           child: const Text(
    //             '질문하기',
    //             style: TextStyle(
    //                 color: Colors.grey, fontFamily: 'godo', fontSize: 30),
    //           ),
    //         );
    //       }
    //     }
    //   },
    // );
  }

  Future<void> _showQuestion(BuildContext context) async {
    double boardX = MediaQuery.of(context).size.width * 0.6;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('현재 공배치를 커뮤니티에 질문합니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => QnaNew(
                      ball: ball,
                      boardX: boardX,
                    ),
                  ),
                );
              },
              child: const Text('예'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
              child: const Text('아니오'),
            ),
          ],
        );
      },
    );
  }

  // Future<void> _showLogin(BuildContext context) async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('알림'),
  //         content: const Text('로그인이 필요합니다.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               Navigator.of(context).push(
  //                 MaterialPageRoute(
  //                   builder: (BuildContext context) => const LoginBack(),
  //                 ),
  //               );
  //             },
  //             child: const Text('로그인'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // 모달 닫기
  //             },
  //             child: const Text('취소'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
