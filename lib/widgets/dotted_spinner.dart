import 'package:flutter/material.dart';

import 'dart:math';

class DottedSpinner extends StatefulWidget {
  final double size;

  final Color color;

  final int dotCount;

  const DottedSpinner({
    Key? key,
    this.size = 50.0,
    this.color = Colors.white,
    this.dotCount = 9,
  }) : super(key: key);

  @override
  _DottedSpinnerState createState() => _DottedSpinnerState();
}

class _DottedSpinnerState extends State<DottedSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: DottedSpinnerPainter(
            dotCount: widget.dotCount,
            color: widget.color,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class DottedSpinnerPainter extends CustomPainter {
  final int dotCount;

  final Color color;

  final double progress;

  DottedSpinnerPainter({
    required this.dotCount,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 3.2;

    final Paint dotPaint = Paint()..color = color;

    final double dotWidth = size.width * 0.1;

    final double dotHeight = size.width * 0.3;

    for (int i = 0; i < dotCount; i++) {
      double angle = (2 * pi * i) / dotCount;

      double fadeFactor = (i / dotCount - progress) % 1;

      fadeFactor = fadeFactor < 0 ? fadeFactor + 1 : fadeFactor;

      fadeFactor = 1 - fadeFactor;

      dotPaint.color = color.withOpacity(0.3 + (fadeFactor * 0.7));

      double x = center.dx + radius * cos(angle);

      double y = center.dy + radius * sin(angle);

      canvas.save();

      canvas.translate(x, y);

      canvas.rotate(angle + pi / 2);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(0, 0), width: dotWidth, height: dotHeight),
          Radius.circular(dotWidth / 2),
        ),
        dotPaint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant DottedSpinnerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
