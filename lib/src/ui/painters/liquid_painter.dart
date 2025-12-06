import 'package:flutter/material.dart';
import 'dart:math' as math;

class LiquidPainter extends CustomPainter {
  final double dragOffset;
  final Color color;
  final bool isRefreshing;
  final bool isSuccess;
  final double maxExtent;

  LiquidPainter({
    required this.dragOffset,
    required this.color,
    required this.isRefreshing,
    required this.isSuccess,
    required this.maxExtent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dragOffset < 1.0) return;

    final w = size.width;
    final h = dragOffset;

    final paint = Paint()
      ..color = isSuccess ? const Color(0xFF4CAF50) : color
      ..style = PaintingStyle.fill;

    // Gradient for a "Soft Matte" depth
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        isSuccess ? const Color(0xFF4CAF50) : color,
        // Slightly darker at the bottom for weight
        isSuccess
            ? const Color(0xFF388E3C)
            : HSLColor.fromColor(color)
                  .withLightness(
                    (HSLColor.fromColor(color).lightness - 0.1).clamp(0.0, 1.0),
                  )
                  .toColor(),
      ],
    );

    final rect = Rect.fromLTWH(0, 0, w, h * 1.5);
    paint.shader = gradient.createShader(rect);

    // A clean, professional elastic curve
    // It acts like a surface tension membrane
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(w, 0);

    // Quadratic Bezier for a perfect smooth arc
    // The control point goes deeper than the end points to create the stretch
    // We only curve the middle section to avoid distorting the edges too much

    // Stable state (Refreshing)
    if (isRefreshing || isSuccess) {
      // A smooth gentle curve at the bottom
      path.lineTo(w, h * 0.8);
      path.quadraticBezierTo(w / 2, h * 1.2, 0, h * 0.8);
    } else {
      // Dragging state
      // The curve deepens as we pull
      // Limit visual height to keep it elegant
      final visualHeight = math.min(h, maxExtent * 1.5);

      path.lineTo(w, 0);

      // Single smooth curve from left to right
      // Control point is in the center, pushed down by the drag
      path.quadraticBezierTo(
        w / 2,
        visualHeight * 1.5, // Push the curve down
        0,
        0,
      );
    }

    path.close();

    // Subtle subtle shadow for depth
    canvas.drawShadow(path, Colors.black.withAlpha(20), 8, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant LiquidPainter oldDelegate) {
    return oldDelegate.dragOffset != dragOffset ||
        oldDelegate.color != color ||
        oldDelegate.isRefreshing != isRefreshing ||
        oldDelegate.isSuccess != isSuccess;
  }
}
