import 'package:flutter/material.dart';

class GameLayout extends StatelessWidget {
  final Widget head_item;
  final List<Widget> body_row;
  final List<Widget> foot_row;

  const GameLayout({
    required this.head_item,
    required this.body_row,
    required this.foot_row,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage('asset/img/background.jpg')),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width *
                  0.8, // 최대 너비를 화면 너비의 80%로 제한
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
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: head_item,
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: body_row,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: foot_row,
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
}
