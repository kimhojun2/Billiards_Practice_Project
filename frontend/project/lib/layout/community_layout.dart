import 'package:flutter/material.dart';
import 'package:project/Screen/community/board_screen.dart';
import 'package:project/Screen/community/community_home.dart';
import 'package:project/Screen/community/profile_screen.dart';
import 'package:project/Screen/community/qna_screen.dart';
import 'package:project/Screen/game/game_home.dart';
import 'package:project/Screen/starting_screen/login_back.dart';
import 'package:project/data/device_manger.dart';
import 'package:project/data/token_manger.dart';

class CommunityLayout extends StatefulWidget {
  final Widget bodyCol;
  final Widget bodyHead;

  const CommunityLayout({
    required this.bodyCol,
    required this.bodyHead,
    super.key,
  });

  @override
  State<CommunityLayout> createState() => _CommunityLayoutState();
}

class _CommunityLayoutState extends State<CommunityLayout> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage('asset/img/background.png')),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset:
          // false,
          true,
          body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width > 600
                  ? MediaQuery.of(context).size.width * 0.8
                  : MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Color(0x808BD1F6),
                      // color: Colors.lightBlue,
                    ),
                    child: Column(
                      children: [
                        _Header(),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: widget.bodyHead,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: widget.bodyCol,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: isClicked ? 0.0 : 30.0,
                    color: Colors.transparent,
                    child: Center(
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                            color: Colors.black12),
                        width: 100,
                        height: 30,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isClicked = true;
                            });
                          },
                          icon: const Icon(Icons.horizontal_split),
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: isClicked ? 65.0 : 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                          // borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20),),
                          border: Border(
                              top: BorderSide(color: Colors.black87, width: 1)),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const CommunityHome(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.home,
                              size: 40,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const BoardScreen(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.comment,
                              size: 40,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isClicked = !isClicked;
                              });
                            },
                            icon: const Icon(
                              Icons.horizontal_split,
                              size: 40,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const QnaScreen(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.question_mark,
                              size: 40,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              int? userSeq = await UserSeqManager.LoadSeq();
                              String? userId = await UserIdManager.LoadId();
                              // print(userSeq);
                              // print(userId);
                              if (userSeq != null && userId != null) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                      currentUser: userSeq,
                                      currentUserId: userId,
                                    ),
                                  ),
                                );
                              } else {
                                // 로그인이 되어 있지 않으면 로그인 모달 또는 페이지를 표시
                                _showLoginModal(context);
                              }
                            },
                            icon: const Icon(
                              Icons.person,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLoginModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그인이 필요합니다'),
          content: const Text('프로필을 보려면 먼저 로그인하세요.'),
          actions: [
            TextButton(
              onPressed: () {
                // 로그인 페이지로 이동 또는 원하는 로그인 처리 로직 수행
                Navigator.of(context).pop(); // 모달 닫기
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LoginBack()));
              },
              child: const Text('로그인'),
            ),
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

class _Header extends StatelessWidget {
  const _Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 11.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CommunityHome(),
                  ),
                );
              },
              child: RichText(
                text: const TextSpan(
                  text: 'Do',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'jua',
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '!', style: TextStyle(color: Colors.yellow)),
                    TextSpan(text: ' 당', style: TextStyle(color: Colors.black)),
                    TextSpan(text: '구', style: TextStyle(color: Colors.black)),
                    TextSpan(text: '당', style: TextStyle(color: Colors.black)),
                    TextSpan(text: '!', style: TextStyle(color: Colors.black)),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                if (MediaQuery.of(context).size.width > 600)
                  IconButton(
                    onPressed: () async {
                      String? divSerial = await DeviceManager.loadDevice();
                      divSerial != null ?
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const GameHome(),
                        ),
                      ) :
                          _showLoginModal(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 40,
                    ),
                  ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_left,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showLoginModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('연결된 기기가 없습니다.'),
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
