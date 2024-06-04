import 'package:flutter/material.dart';
import 'package:project/Screen/game/game_play.dart';
import 'package:project/Screen/game/practice_first.dart';
import 'package:project/Screen/game/trial_mode.dart';
import 'package:project/Screen/starting_screen/device_disconnect.dart';
import 'package:project/Screen/starting_screen/login_back.dart';
import 'package:project/component/game_component/com_button.dart';
import 'package:project/component/set_device_state.dart';
import 'package:project/data/device_manger.dart';
import 'package:project/data/token_manger.dart';
import 'package:project/layout/mode_layout.dart';

class GameHome extends StatelessWidget {
  const GameHome({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;

    return ModeLayout(
      headItem:
          const _Head(),
      bodyRow: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: phoneHeight * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
                border: Border.all(color: Colors.brown, width: 5),
                image: const DecorationImage(
                  image: AssetImage('asset/img/3ball_start.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const GamePlay(),
                    ),
                  );
                },
                child: const Text(''),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: phoneHeight * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
                border: Border.all(color: Colors.brown, width: 5),
                image: const DecorationImage(
                  image: AssetImage('asset/img/practice_start.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: TextButton(
                onPressed: () async {
                  int? userSeq = await UserSeqManager.LoadSeq();
                  String? deviceSeqStr = await DeviceManager.loadDevice();
                  int deviceSeq = (deviceSeqStr != null) ? int.parse(deviceSeqStr) : 0;
                  if (userSeq != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => PracticeFirst(
                          deviceSeq: deviceSeq,
                        ),
                      ),
                    );
                    SetDeviceState('0');
                  } else {
                    return _showLoginModal(context);
                  }
                },
                child: const Text(''),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: phoneHeight * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
                border: Border.all(color: Colors.brown, width: 5),
                image: const DecorationImage(
                  image: AssetImage('asset/img/trial_start.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: TextButton(
                onPressed: () async {
                  int? userSeq = await UserSeqManager.LoadSeq();
                  if (userSeq != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        // builder: (context) => const TrialLevel(),
                        builder: (context) => const TrialHome(),
                      ),
                    );
                  } else {
                    return _showLoginModal(context);
                  }
                },
                child: const Text(''),
              ),
            ),
          ),
        ),
      ],
      footRow: [
        const Text(''),
        TextButton(
          onPressed: () {
            _showWarning(context);
          },
          child: const Text(
            'Disconnect',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }

  void _showLoginModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('로그인이 필요한 서비스 입니다.'),
          actions: [
            TextButton(
              onPressed: () {
                // 로그인 페이지로 이동 또는 원하는 로그인 처리 로직 수행
                Navigator.of(context).pop(); // 모달 닫기
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const LoginBack()));
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

  Future<void> _showWarning(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('주의!'),
          content: const Text('앱과 기기의 연결이 해제됩니다!\n'
              '일반고객은 취소버튼을 눌러주세요'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // _showAnswerModal(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const DeviceDisconnect(),
                  ),
                );
              },
              child: const Text('연결 해제'),
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

class _Head extends StatelessWidget {
  const _Head({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(''),
        CommunityButton(),
      ],
    );
  }
}
