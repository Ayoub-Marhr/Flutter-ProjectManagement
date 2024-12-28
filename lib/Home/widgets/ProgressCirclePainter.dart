import 'package:flutter/material.dart';

class ProgressCirclePainter extends CustomPainter {
  final double progress;

  const ProgressCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    Paint progressPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    double center = size.width / 2;
    double radius = center - 8;

    canvas.drawCircle(Offset(center, center), radius, backgroundPaint);

    double angle = 2 * 3.14159265359 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(center, center), radius: radius),
      -3.14159265359 / 2,
      angle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
