import 'package:flutter/material.dart';
import 'package:project/component/game_component/play_score.dart';
import 'package:project/data/token_manger.dart';
import 'package:project/layout/play_layout.dart';
import 'package:project/style/game_button.dart';
import 'package:project/Screen/game/game_home.dart';
import 'dart:async';


class GamePlay extends StatelessWidget {
  const GamePlay({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;

    return PlayLayout(
      headWidget: const _Head(),
      bodyWidget:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: phoneHeight * 0.04,
            ),
            PlayerList(),
          ],
        ),
    );
  }
}

class _Head extends StatelessWidget {
  const _Head({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          width: phoneWidth * 0.06,
          height: phoneHeight * 0.09,
          child: IconButton(onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset(
            'asset/icon/home.png',
          ),),
        ),
        Row(children: [
          Container(
            child: const _TimerWidget(),
          ),
        ]),
      ],
    );
  }
}


class PlayerList extends StatefulWidget {
  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  List<PlayerScore> players = [];
  int playerIdCounter = 1;

  @override
  void initState() {
    super.initState();

    // 초기에 하나의 플레이어 추가
    players.add(PlayerScore(
      playerId: playerIdCounter,
      onDelete: (playerId) {
        setState(() {
          players.removeWhere((player) => player.playerId == playerId);
        });
      },
    ));
    playerIdCounter++;
  }

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Column(
            children: players.map((player) {
              return Column(
                children: [
                  player,
                  SizedBox(height: phoneHeight * 0.015),
                ],
              );
            }).toList(),
          ),
          SizedBox(height: phoneHeight * 0.01),
          Padding(
            padding: EdgeInsets.only(right: phoneHeight * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (players.length < 4)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        players.add(PlayerScore(
                          playerId: playerIdCounter,
                          onDelete: (playerId) {
                            setState(() {
                              players.removeWhere(
                                      (player) => player.playerId == playerId);
                            });
                          },
                        ));
                        playerIdCounter++;
                      });
                    },
                    style: gameButton,
                    child: Text(
                      "플레이어 추가",
                      style: TextStyle(fontSize: phoneHeight * 0.04, color: Colors.black),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerWidget extends StatefulWidget {
  const _TimerWidget({super.key});

  @override
  State<_TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<_TimerWidget> {
  bool timerStarted = false; // 타이머 시작 여부
  Duration timerDuration = const Duration(seconds: 0); // 타이머 경과 시간

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              border: Border.all(color: Colors.black)
          ),
          width: phoneWidth * 0.17,
          height: phoneHeight * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.asset('asset/icon/settings.png'),
              Icon(Icons.watch_later_outlined, size: phoneHeight * 0.04,),
              Text(
                timerDurationToString(),
                style: TextStyle(fontSize: phoneHeight * 0.035, fontFamily: 'godo'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: phoneHeight * 0.1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.grey,
              backgroundColor: const Color(0xEAEAEAFF),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0)
                  ),
                  side: BorderSide(color: Colors.black)
              ),
              padding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
            ),
            onPressed: () {
              // 시작 버튼을 누르면 타이머 시작 또는 중지
              setState(() {
                if (timerStarted) {
                  // 타이머가 이미 시작 중이면 중지
                  _timerstop(context);
                } else {
                  // 타이머가 시작되지 않았으면 시작
                  timerStarted = true;
                  startTimer();
                }
              });
            },
            child: Text(
              timerStarted ? '중지' : '시작',
              style: TextStyle(
                fontSize: phoneHeight * 0.038,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void startTimer() {
    // 1초마다 타이머 갱신
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerStarted) {
        // 타이머가 시작 중이면 1초씩 증가
        setState(() {
          timerDuration = timerDuration + const Duration(seconds: 1);
        });
      } else {
        // 타이머가 중지되면 타이머 중지
        timer.cancel();
      }
    });
  }

  Future<void> _timerstop(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림', style: TextStyle(fontFamily: 'godo', fontSize: 30),),
          content: const Text('사용을 종료하시겠습니까?', style: TextStyle(fontFamily: 'godo', fontSize: 15),),
          actions: [
            TextButton(
              onPressed: () {
                timerStarted = false;
                Navigator.of(context).pop();
                TokenManager.logout();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const GameHome(),
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

  String timerDurationToString() {
    // Duration을 시간:분:초 형태의 문자열로 변환
    int hours = timerDuration.inHours;
    int minutes = (timerDuration.inMinutes % 60);
    int seconds = (timerDuration.inSeconds % 60);
    String formattedHour = hours < 10 ? '0$hours' : '$hours';
    String formattedminutes = minutes < 10 ? '0$minutes' : '$minutes';
    String formattedseconds = seconds < 10 ? '0$seconds' : '$seconds';
    return ' $formattedHour : $formattedminutes : $formattedseconds';
  }
}
