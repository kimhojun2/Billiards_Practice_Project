import 'package:flutter/material.dart';

class StartingLayout extends StatelessWidget {
  final Widget startBody;

  const StartingLayout({required this.startBody, super.key});

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage('asset/img/background2_dark.png')),
      ),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset:
          false,
          // true,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: phoneWidth * 0.06), // 좌우에 16.0 픽셀 간격
              // 또는
              constraints: BoxConstraints(
                  maxWidth: phoneWidth > phoneHeight ? phoneWidth * 0.45 : phoneWidth,
              ),
              child: startBody,
            ),
          ),
        ),
      ),
    );
  }
}
