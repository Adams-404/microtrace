import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

enum BadgeType {
  pass,
  warning,
  danger,
  modelPrediction,
  humanObservation,
  neutral,
}

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
    Color bg;
    Color border;
    Color fg;

    switch (type) {
      case BadgeType.pass:
        bg = AppColors.passGreen.withOpacity(0.12);
        border = AppColors.passGreen.withOpacity(0.4);
        fg = AppColors.passGreen;
        break;
      case BadgeType.warning:
        bg = AppColors.warningAmber.withOpacity(0.12);
        border = AppColors.warningAmber.withOpacity(0.4);
        fg = AppColors.warningAmber;
        break;
      case BadgeType.danger:
        bg = AppColors.dangerRose.withOpacity(0.12);
        border = AppColors.dangerRose.withOpacity(0.4);
        fg = AppColors.dangerRose;
        break;
      case BadgeType.modelPrediction:
        bg = AppColors.modelPredictionPurple.withOpacity(0.12);
        border = AppColors.modelPredictionPurple.withOpacity(0.45);
        fg = const Color(0xFFA78BFA);
        break;
      case BadgeType.humanObservation:
        bg = AppColors.cyan.withOpacity(0.12);
        border = AppColors.cyan.withOpacity(0.45);
        fg = AppColors.cyan;
        break;
      case BadgeType.neutral:
        final isDark = Theme.of(context).brightness == Brightness.dark;
        bg = isDark
            ? AppColors.darkSurfaceSubtle
            : AppColors.lightSurfaceSubtle;
        border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
        fg = isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 9,
        vertical: isCompact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isCompact ? 11 : 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: AppTypography.technicalMono(
              fg,
              fontSize: isCompact ? 10 : 11,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
