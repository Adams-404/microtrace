import 'dart:math' as math;

import 'package:flutter/material.dart';

/// MICROTRACE AI mark: a five-spore colony connected by thin filaments.
///
/// Deliberately not a star, sparkle or robot: it reads as a fungal colony
/// under a lens, tying the copilot to the microscopy instrument.
class AiMark extends StatelessWidget {
  final double size;
  final Color? color;
  final bool glow;

  const AiMark({super.key, this.size = 20, this.color, this.glow = false});

  @override
  Widget build(BuildContext context) {
    final tint = color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _AiMarkPainter(tint: tint, glow: glow),
      ),
    );
  }
}

class _AiMarkPainter extends CustomPainter {
  final Color tint;
  final bool glow;

  _AiMarkPainter({required this.tint, required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final center = Offset(size.width / 2, size.height / 2);

    // Corner spore positions (quincunx) with slightly organic offsets.
    final nodes = <Offset>[
      center + const Offset(-0.265, -0.245) * s,
      center + const Offset(0.255, -0.26) * s,
      center + const Offset(0.27, 0.245) * s,
      center + const Offset(-0.25, 0.255) * s,
    ];

    if (glow) {
      final halo = Paint()
        ..color = tint.withValues(alpha: 0.16)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * 0.16);
      for (final node in nodes) {
        canvas.drawCircle(node, s * 0.13, halo);
      }
      canvas.drawCircle(center, s * 0.18, halo);
    }

    final filament = Paint()
      ..color = tint.withValues(alpha: 0.55)
      ..strokeWidth = math.max(1.0, s * 0.032)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final node in nodes) {
      canvas.drawLine(center, node, filament);
    }

    final dot = Paint()..style = PaintingStyle.fill;

    const radii = [0.082, 0.094, 0.08, 0.088];
    for (var i = 0; i < nodes.length; i++) {
      dot.color = tint.withValues(alpha: 0.82);
      canvas.drawCircle(nodes[i], s * radii[i], dot);
    }

    canvas.saveLayer(Offset.zero & size, Paint());
    dot
      ..color = tint
      ..blendMode = BlendMode.srcOver;
    canvas.drawCircle(center, s * 0.115, dot);

    // Punch a lens-like hole in the colony centre.
    dot
      ..blendMode = BlendMode.clear
      ..color = Colors.transparent;
    canvas.drawCircle(center, s * 0.042, dot);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AiMarkPainter oldDelegate) {
    return oldDelegate.tint != tint || oldDelegate.glow != glow;
  }
}
