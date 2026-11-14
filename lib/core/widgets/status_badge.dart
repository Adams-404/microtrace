import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';
import '../../app/theme/app_typography.dart';

enum BadgeType {
  pass,
  warning,
  danger,
  modelPrediction,
  humanObservation,
  neutral,
}

/// Status pill. A leading dot carries the state so color is never the only
/// signal, and the label stays in the mono face for instrument consistency.
class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final IconData? icon;
  final bool isCompact;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.neutral,
    this.icon,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    late final Color fg;
    switch (type) {
      case BadgeType.pass:
        fg = t.success;
        break;
      case BadgeType.warning:
        fg = t.warning;
        break;
      case BadgeType.danger:
        fg = t.danger;
        break;
      case BadgeType.modelPrediction:
        fg = t.violet;
        break;
      case BadgeType.humanObservation:
        fg = t.accent;
        break;
      case BadgeType.neutral:
        fg = t.textSecondary;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 10,
        vertical: isCompact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isCompact ? 11 : 12, color: fg),
            const SizedBox(width: 5),
          ] else ...[
            Container(
              width: isCompact ? 4.5 : 5.5,
              height: isCompact ? 4.5 : 5.5,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label.toUpperCase(),
            style: AppTypography.technicalMono(
              fg,
              fontSize: isCompact ? 9 : 10,
              weight: FontWeight.w700,
            ).copyWith(letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}
