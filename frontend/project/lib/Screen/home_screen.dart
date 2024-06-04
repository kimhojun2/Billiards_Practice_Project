import 'package:flutter/material.dart';
import 'package:project/Screen/community/community_home.dart';
import 'package:project/Screen/game/game_home.dart';
import 'package:project/Screen/starting_screen/device_connect.dart';
import 'package:project/Screen/starting_screen/login.dart';
import 'package:project/data/device_manger.dart';
import 'package:project/data/token_manger.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage('asset/img/background2.png')),
      ),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              constraints: const BoxConstraints(maxWidth: 400.0),
              child: const _Body(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({super.key});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  String? _userToken;

  @override
  void initState() {
    super.initState();
    _loadToken(); // 토큰을 불러오는 함수 호출
  }

  Future<void> _loadToken() async {
    String? token = await TokenManager.loadToken(); // 토큰을 로드하는 함수
    setState(() {
      _userToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RichText(
                text: const TextSpan(
                  text: 'Do',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'jua',
                    fontSize: 62,
                    fontWeight: FontWeight.w700,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '!', style: TextStyle(color: Colors.yellow)),
                    TextSpan(text: ' 당', style: TextStyle(color: Colors.white)),
                    TextSpan(text: '구', style: TextStyle(color: Colors.white)),
                    TextSpan(text: '당', style: TextStyle(color: Colors.white)),
                    TextSpan(text: '!', style: TextStyle(color: Colors.white)),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Do & Play Billiard',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'dance', fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        const Expanded(
          flex: 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (BuildContext context) => GameHome(),
              //       ),
              //     );
              //   },
              //   child: Text(
              //     '디버그-게임 링크',
              //     style: TextStyle(color: Colors.white, fontSize: 30),
              //   ),
              // ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (BuildContext context) => const CommunityHome(),
              //       ),
              //     );
              //   },
              //   child: const Text(
              //     '디버그-커뮤니티 링크',
              //     style: TextStyle(color: Colors.white, fontSize: 30),
              //   ),
              // ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              FutureBuilder<String?>(
                future: TokenManager.loadToken(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('123Error: ${snapshot.error}');
                  } else {
                    final String userToKen = snapshot.data ?? '';
                    return userToKen == ''
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Login(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 40.0),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                // side: BorderSide(color: Colors.black, width: 3)
                              ),
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'godo',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        : ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CommunityHome(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 40.0),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // side: BorderSide(color: Colors.black, width: 3)
                        ),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'godo',
                            fontSize: 28,
                            fontWeight: FontWeight.w700),
                      ),
                    );
                    // TextButton(
                    //         onPressed: () {
                    //           Navigator.of(context).push(
                    //             MaterialPageRoute(
                    //               builder: (context) => const CommunityHome(),
                    //             ),
                    //           );
                    //         },
                    //         child: AnimatedText());
                  }
                },
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FutureBuilder<String?>(
                    future: DeviceManager.loadDevice(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('123Error: ${snapshot.error}');
                      } else {
                        final String deviceSeq = snapshot.data ?? '';
                        return deviceSeq == ''
                            ? TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const DeviceConnect(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  '기기연결',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const GameHome(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  '게임홈으로',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnimatedText extends StatefulWidget {
  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      reverseDuration: const Duration(milliseconds: 300),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _animationController.value,
          child: const Text(
            'Touch to Enter',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
