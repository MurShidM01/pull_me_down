import 'package:flutter/material.dart';
import 'dart:math' as math;

class LiquidSpinner extends StatefulWidget {
  final Color color;
  const LiquidSpinner({super.key, required this.color});

  @override
  State<LiquidSpinner> createState() => _LiquidSpinnerState();
}

class _LiquidSpinnerState extends State<LiquidSpinner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
        return Transform.scale(
          scale: 1.0 + (0.1 * math.sin(_controller.value * 2 * math.pi)), // Breathing effect
          child: CustomPaint(
            size: const Size(30, 30),
            painter: _SpinnerPainter(
              color: widget.color,
              rotation: _controller.value * 2 * math.pi,
            ),
          ),
        );
      },
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  final Color color;
  final double rotation;

  _SpinnerPainter({required this.color, required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - 2;
    
    // Determine contrast color
    final spinnerColor = color.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

    final paint = Paint()
      ..color = spinnerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    
    // Native-like arc that grows and shrinks
    // We simulate this by rotating
    // A gap of 90 degrees
    canvas.drawArc(rect, rotation, (3 * math.pi) / 2, false, paint);
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) {
    return oldDelegate.rotation != rotation || oldDelegate.color != color;
  }
}
