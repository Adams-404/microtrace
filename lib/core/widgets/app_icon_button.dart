import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';
import '../utils/haptics.dart';

/// Compact circular icon action used in app bars and card corners.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool showDot;
  final Color? color;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.showDot = false,
    this.color,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final button = SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: t.surfaceHigh.withValues(alpha: t.isDark ? 0.7 : 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size / 2.8),
              side: BorderSide(color: t.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed == null
                  ? null
                  : () {
                      Haptics.tap();
                      onPressed!();
                    },
              child: Icon(icon, size: 20, color: color ?? t.textSecondary),
            ),
          ),
          if (showDot)
            Positioned(
              right: 9,
              top: 9,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: t.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: t.surface, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}
