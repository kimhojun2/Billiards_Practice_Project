import 'package:flutter/material.dart';
import 'package:project/data/ball_location.dart';

class QnaDrawing extends StatefulWidget {
  final Positions ballPositions;
  final double boardX;
  final BilliardInfo billiardInfo;

  const QnaDrawing({
    required this.ballPositions,
    required this.boardX,
    required this.billiardInfo,
    super.key,
  });

  @override
  State<QnaDrawing> createState() => _QnaDrawingState();
}

class _QnaDrawingState extends State<QnaDrawing> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 77 / 42,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/img/empty_board.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: widget.boardX * 0.05, vertical: widget.boardX * 0.05),
          child: Center(
            child: CustomPaint(
              // painter: RoutePainter(testPositions),
              painter: RoutePainter(
                widget.ballPositions,
                widget.boardX * 0.9 / widget.billiardInfo.boardX,
                widget.boardX * 0.45 / widget.billiardInfo.boardY,
                widget.billiardInfo.ballDiameter * widget.boardX / widget.billiardInfo.boardX * 0.45,
              ),
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }
}

class RoutePainter extends CustomPainter {
  Positions ballPositions; // 공의 좌표값 리스트
  double ratioX;
  double ratioY;
  double ballSize;

  RoutePainter(
      this.ballPositions,
      this.ratioX,
      this.ratioY,
      this.ballSize,
      );

  @override
  void paint(Canvas canvas, Size size) {
    List<List<double>> _Red = ballPositions.red;
    List<List<double>> _White = ballPositions.white;
    List<List<double>> _Yellow = ballPositions.yellow;
    double ballsize = ballSize;

    if (_Red.isNotEmpty) {
      canvas.drawCircle(
        Offset(_Red[0][0] * ratioX + 5, _Red[0][1] * ratioY + 3),
        ballsize,
        Paint()
          ..color = Colors.black.withOpacity(0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2)
          ..filterQuality = FilterQuality.low,
      );
      canvas.drawCircle(
        Offset(_Red[0][0] * ratioX, _Red[0][1] * ratioY),
        ballsize,
        Paint()
          ..color = Colors.red,
      );
    }
    if (_White.isNotEmpty) {
      canvas.drawCircle(
        Offset(_White[0][0] * ratioX + 5, _White[0][1] * ratioY + 3),
        ballsize,
        Paint()
          ..color = Colors.black.withOpacity(0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2)
          ..filterQuality = FilterQuality.low,
      );
      canvas.drawCircle(
        Offset(_White[0][0] * ratioX, _White[0][1] * ratioY),
        ballsize,
        Paint()
          ..color = Colors.white,
      );
    }
    if (_Yellow.isNotEmpty) {
      canvas.drawCircle(
        Offset(_Yellow[0][0] * ratioX + 5, _Yellow[0][1] * ratioY + 3),
        ballsize,
        Paint()
          ..color = Colors.black.withOpacity(0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2)
          ..filterQuality = FilterQuality.low,
      );
      canvas.drawCircle(
        Offset(_Yellow[0][0] * ratioX, _Yellow[0][1] * ratioY),
        ballsize,
        Paint()
          ..color = Colors.yellow,
      );
    }
  }

  @override
  bool shouldRepaint(RoutePainter oldDelegate) {
    return true;
  }
}