import 'package:flutter/material.dart';

class PlayLayout extends StatelessWidget {
  final Widget headWidget;
  final Widget bodyWidget;

  const PlayLayout({
    required this.headWidget,
    required this.bodyWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage('asset/img/only_board.png')),
      ),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width *
                    0.9, // 최대 너비를 화면 너비의 80%로 제한
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: headWidget,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: bodyWidget,
                    ),
                    // Spacer(),
                    // Container(
                    //   child: _TimerWidget(),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}