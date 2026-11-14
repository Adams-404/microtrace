import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Clean scientific card with crisp borders, subtle surfaces, and no excessive shadows.
class ScientificCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderWidth;
  final double borderRadius;

  const ScientificCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.borderColor,
    this.backgroundColor,
    this.borderWidth = 1.0,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultBg = backgroundColor ?? (isDark ? AppColors.darkSurface : AppColors.lightSurface);
    final defaultBorder = borderColor ?? (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: defaultBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: defaultBorder, width: borderWidth),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: content,
        ),
      );
    }

    return content;
  }
}
