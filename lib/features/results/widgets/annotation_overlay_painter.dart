import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/models/annotation.dart';

class AnnotationOverlayPainter extends CustomPainter {
  final List<Annotation> annotations;
  final bool showLabels;

  AnnotationOverlayPainter({required this.annotations, this.showLabels = true});

  @override
  void paint(Canvas canvas, Size size) {
    for (final ann in annotations) {
      final box = ann.boxNormalized;
      final rect = Rect.fromLTWH(
        box.x * size.width,
        box.y * size.height,
        box.width * size.width,
        box.height * size.height,
      );

      final boxPaint = Paint()
        ..color = AppColors.cyan.withOpacity(0.2)
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = AppColors.cyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      // Draw highlighted region
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        boxPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        borderPaint,
      );

      // Corner markers
      final cornerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      const cornerLen = 8.0;
      // Top-Left
      canvas.drawLine(
        rect.topLeft,
        rect.topLeft + const Offset(cornerLen, 0),
        cornerPaint,
      );
      canvas.drawLine(
        rect.topLeft,
        rect.topLeft + const Offset(0, cornerLen),
        cornerPaint,
      );
      // Top-Right
      canvas.drawLine(
        rect.topRight,
        rect.topRight + const Offset(-cornerLen, 0),
        cornerPaint,
      );
      canvas.drawLine(
        rect.topRight,
        rect.topRight + const Offset(0, cornerLen),
        cornerPaint,
      );
      // Bottom-Left
      canvas.drawLine(
        rect.bottomLeft,
        rect.bottomLeft + const Offset(cornerLen, 0),
        cornerPaint,
      );
      canvas.drawLine(
        rect.bottomLeft,
        rect.bottomLeft + const Offset(0, -cornerLen),
        cornerPaint,
      );
      // Bottom-Right
      canvas.drawLine(
        rect.bottomRight,
        rect.bottomRight + const Offset(-cornerLen, 0),
        cornerPaint,
      );
      canvas.drawLine(
        rect.bottomRight,
        rect.bottomRight + const Offset(0, -cornerLen),
        cornerPaint,
      );

      if (showLabels) {
        final textSpan = TextSpan(
          text:
              ' ${ann.label} (${(ann.confidence * 100).toStringAsFixed(0)}%) ',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        )..layout();

        final bgRect = Rect.fromLTWH(
          rect.left,
          rect.top - 16,
          textPainter.width + 4,
          16,
        );
        canvas.drawRect(bgRect, Paint()..color = AppColors.cyan);
        textPainter.paint(canvas, Offset(rect.left + 2, rect.top - 15));
      }
    }
  }

  @override
  bool shouldRepaint(covariant AnnotationOverlayPainter oldDelegate) => true;
}
