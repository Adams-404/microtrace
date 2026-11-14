import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';
import '../utils/haptics.dart';

/// Elevated instrument surface: hairline border, soft top-light gradient and
/// a single 20px radius. No drop shadows on resting cards so the dark UI stays
/// flat and calm; the border carries the separation.
class ScientificCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderWidth;
  final double borderRadius;
  final bool glow;

  const ScientificCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.borderColor,
    this.backgroundColor,
    this.borderWidth = 1.0,
    this.borderRadius = 20.0,
    this.glow = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final base = backgroundColor ?? t.surface;
    final border = borderColor ?? t.border;

    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: border, width: borderWidth),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: t.accent.withValues(alpha: 0.10),
                  blurRadius: 28,
                  spreadRadius: -10,
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () {
            Haptics.tap();
            onTap!();
          },
          child: content,
        ),
      );
    }

    return content;
  }
}
