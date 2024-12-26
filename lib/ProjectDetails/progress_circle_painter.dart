import 'package:flutter/material.dart';

class ProgressCirclePainter extends CustomPainter {
  final double progress;

  const ProgressCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = Colors.grey.withOpacity(0.2);

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );

    paint
      ..color = Colors.yellow
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double angle = 2 * 3.1416 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      -3.1416 / 2,
      angle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
