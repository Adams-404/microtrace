import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

class MicroscopeReticleOverlay extends StatelessWidget {
  final bool showGraticule;
  final bool showApertureRing;
  final double sharpnessScore; // 0 to 100
  final String opticalProfile;
  final bool isSimulated;

  const MicroscopeReticleOverlay({
    super.key,
    this.showGraticule = true,
    this.showApertureRing = true,
    this.sharpnessScore = 84.5,
    this.opticalProfile = '40x Achromat • Brightfield',
    this.isSimulated = true,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _ReticlePainter(
              showGraticule: showGraticule,
              showApertureRing: showApertureRing,
            ),
          ),
          // Top Status Bar Overlay
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.signal.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.passGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isSimulated ? 'SIMULATED FEED' : 'OPTICAL CAM',
                          style: AppTypography.technicalMono(
                            Colors.white,
                            fontSize: 10,
                            weight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '| $opticalProfile',
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.technicalMono(
                              Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: sharpnessScore > 70
                          ? AppColors.passGreen.withOpacity(0.5)
                          : AppColors.warningAmber.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.center_focus_strong,
                        size: 11,
                        color: sharpnessScore > 70
                            ? AppColors.passGreen
                            : AppColors.warningAmber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'FOCUS: ${sharpnessScore.toStringAsFixed(1)} (PASS)',
                        style: AppTypography.technicalMono(
                          sharpnessScore > 70
                              ? AppColors.passGreen
                              : AppColors.warningAmber,
                          fontSize: 10,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Graticule Scale bar (e.g. 25 µm calibration)
          Positioned(
            bottom: 16,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(width: 1, height: 6, color: Colors.white),
                      Container(width: 60, height: 2, color: Colors.white),
                      Container(width: 1, height: 6, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '25 µm (CALIBRATED)',
                    style: AppTypography.technicalMono(
                      Colors.white70,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReticlePainter extends CustomPainter {
  final bool showGraticule;
  final bool showApertureRing;

  _ReticlePainter({
    required this.showGraticule,
    required this.showApertureRing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.44;

    final ringPaint = Paint()
      ..color = AppColors.signal.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final subRingPaint = Paint()
      ..color = AppColors.signal.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final crosshairPaint = Paint()
      ..color = AppColors.signal.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    if (showApertureRing) {
      // Main circular field aperture
      canvas.drawCircle(center, radius, ringPaint);
      // Secondary concentric guide
      canvas.drawCircle(center, radius * 0.72, subRingPaint);
      // Center target ring
      canvas.drawCircle(center, 24, subRingPaint);
    }

    if (showGraticule) {
      const centerGap = 16.0;
      // Crosshairs with central gap
      // Left
      canvas.drawLine(
        Offset(center.dx - radius, center.dy),
        Offset(center.dx - centerGap, center.dy),
        crosshairPaint,
      );
      // Right
      canvas.drawLine(
        Offset(center.dx + centerGap, center.dy),
        Offset(center.dx + radius, center.dy),
        crosshairPaint,
      );
      // Top
      canvas.drawLine(
        Offset(center.dx, center.dy - radius),
        Offset(center.dx, center.dy - centerGap),
        crosshairPaint,
      );
      // Bottom
      canvas.drawLine(
        Offset(center.dx, center.dy + centerGap),
        Offset(center.dx, center.dy + radius),
        crosshairPaint,
      );

      // Micrometer tick marks along horizontal and vertical axes
      final tickPaint = Paint()
        ..color = AppColors.signal.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      for (double d = 30; d < radius; d += 20) {
        final tickLen = (d % 60 == 0) ? 6.0 : 3.0;
        // Horizontal ticks
        canvas.drawLine(
          Offset(center.dx + d, center.dy - tickLen),
          Offset(center.dx + d, center.dy + tickLen),
          tickPaint,
        );
        canvas.drawLine(
          Offset(center.dx - d, center.dy - tickLen),
          Offset(center.dx - d, center.dy + tickLen),
          tickPaint,
        );
        // Vertical ticks
        canvas.drawLine(
          Offset(center.dx - tickLen, center.dy + d),
          Offset(center.dx + tickLen, center.dy + d),
          tickPaint,
        );
        canvas.drawLine(
          Offset(center.dx - tickLen, center.dy - d),
          Offset(center.dx + tickLen, center.dy - d),
          tickPaint,
        );
      }

      // Radial angle tick marks
      for (int deg = 0; deg < 360; deg += 30) {
        final rad = deg * math.pi / 180;
        final r1 = radius - 6;
        final r2 = radius;
        final p1 = Offset(
          center.dx + r1 * math.cos(rad),
          center.dy + r1 * math.sin(rad),
        );
        final p2 = Offset(
          center.dx + r2 * math.cos(rad),
          center.dy + r2 * math.sin(rad),
        );
        canvas.drawLine(p1, p2, tickPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ReticlePainter oldDelegate) => false;
}
