import 'package:flutter/material.dart';
import 'package:project/component/game_component/game_head.dart';
import 'package:project/component/game_component/trial_mode_select.dart';
import 'package:project/layout/mode_layout.dart';

class TrialHome extends StatelessWidget {
  const TrialHome({super.key});

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;

    return ModeLayout(
      headItem:
          // Text(''),
          const GameHead(),
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
                  image: AssetImage('asset/img/quizselect1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    // builder: (BuildContext context) => const TrialBasic(),
                    builder: (BuildContext context) => const TrialMode(
                      modeNum: 1,
                      modeName: '기본기',
                      quizName1: '3구 초구',
                      quizName2: '앞돌리기',
                      quizName3: '뒤돌려치기',
                      quizName4: '제각돌리기',
                    ),
                  ));
                },
                child: Text(
                  '기본기\n\n\n',
                  style: TextStyle(
                      fontSize: phoneHeight * 0.07,
                      fontFamily: 'jua',
                      color: Colors.white),
                ),
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
                  image: AssetImage('asset/img/quizselect4.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      // builder: (BuildContext context) => const TrialGR(),
                      builder: (BuildContext context) => const TrialMode(
                        modeNum: 2,
                        modeName: '중급',
                        quizName1: '빗겨치기',
                        quizName2: '대회전',
                        quizName3: '횡단',
                        quizName4: '리버스 돌려치기',
                      ),
                    ),
                  );
                  // SetDeviceState('0');
                },
                child: Text(
                  '중급\n\n\n',
                  style: TextStyle(
                      fontSize: phoneHeight * 0.07,
                      fontFamily: 'jua',
                      color: Colors.white),
                ),
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
                  image: AssetImage('asset/img/quizselect3.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      // builder: (context) => const TrialReverse(),
                      builder: (BuildContext context) => const TrialMode(
                        modeNum: 3,
                        modeName: '고급',
                        quizName1: '넣어치기',
                        quizName2: '걸어치기',
                        quizName3: '빈쿠션',
                        quizName4: '되돌리기',
                      ),
                    ),
                  );
                },
                child: Text(
                  '고급\n\n\n',
                  style: TextStyle(
                      fontSize: phoneHeight * 0.07,
                      fontFamily: 'jua',
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
      footRow: const [
        Text(''),
      ],
    );
  }
}
