import 'package:flutter/material.dart';

class EllipsePainter extends CustomPainter {
  final Color color;
  final double width;
  final double height;

  EllipsePainter({required this.color,required this.width, required this.height});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    path.addOval(Rect.fromLTWH(0, 0, width, height));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}