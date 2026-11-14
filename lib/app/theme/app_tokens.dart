import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic surface + accent tokens resolved per theme.
///
/// Widgets should read these through [AppTokensX.tokens] instead of branching
/// on `Theme.of(context).brightness`. Keeps every screen on one palette.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  final Color bg;
  final Color surface;
  final Color surfaceHigh;
  final Color border;
  final Color borderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color accentSoft;
  final Color onAccent;
  final Color success;
  final Color warning;
  final Color danger;
  final Color violet;
  final LinearGradient heroGradient;
  final bool isDark;

  const AppTokens({
    required this.bg,
    required this.surface,
    required this.surfaceHigh,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.success,
    required this.warning,
    required this.danger,
    required this.violet,
    required this.heroGradient,
    required this.isDark,
  });

  static const AppTokens dark = AppTokens(
    bg: AppColors.darkBg,
    surface: AppColors.darkSurface,
    surfaceHigh: AppColors.darkSurfaceHigh,
    border: AppColors.darkBorder,
    borderStrong: AppColors.darkBorderStrong,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textMuted: AppColors.darkTextMuted,
    accent: AppColors.cyan,
    accentSoft: Color(0x1F4CC9F0),
    onAccent: Color(0xFF04131C),
    success: AppColors.passGreen,
    warning: AppColors.warningAmber,
    danger: AppColors.dangerRose,
    violet: AppColors.modelPredictionPurple,
    heroGradient: AppColors.heroGradientDark,
    isDark: true,
  );

  static const AppTokens amoled = AppTokens(
    bg: AppColors.amoledBg,
    surface: AppColors.amoledSurface,
    surfaceHigh: AppColors.amoledSurfaceHigh,
    border: AppColors.amoledBorder,
    borderStrong: AppColors.amoledBorderStrong,
    textPrimary: AppColors.amoledTextPrimary,
    textSecondary: AppColors.amoledTextSecondary,
    textMuted: AppColors.amoledTextMuted,
    accent: AppColors.cyan,
    accentSoft: Color(0x1F4CC9F0),
    onAccent: Color(0xFF04131C),
    success: AppColors.passGreen,
    warning: AppColors.warningAmber,
    danger: AppColors.dangerRose,
    violet: AppColors.modelPredictionPurple,
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF06222C), Color(0xFF071A20), Color(0xFF000000)],
      stops: [0.0, 0.55, 1.0],
    ),
    isDark: true,
  );

  static const AppTokens light = AppTokens(
    bg: AppColors.lightBg,
    surface: AppColors.lightSurface,
    surfaceHigh: AppColors.lightSurfaceHigh,
    border: AppColors.lightBorder,
    borderStrong: AppColors.lightBorderStrong,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    textMuted: AppColors.lightTextMuted,
    accent: AppColors.cyanDeep,
    accentSoft: Color(0x1A0284C7),
    onAccent: Colors.white,
    success: Color(0xFF059669),
    warning: Color(0xFFD97706),
    danger: Color(0xFFE11D48),
    violet: Color(0xFF7C3AED),
    heroGradient: AppColors.heroGradientLight,
    isDark: false,
  );

  @override
  AppTokens copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceHigh,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accent,
    Color? accentSoft,
    Color? onAccent,
    Color? success,
    Color? warning,
    Color? danger,
    Color? violet,
    LinearGradient? heroGradient,
    bool? isDark,
  }) {
    return AppTokens(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      onAccent: onAccent ?? this.onAccent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      violet: violet ?? this.violet,
      heroGradient: heroGradient ?? this.heroGradient,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceHigh: Color.lerp(surfaceHigh, other.surfaceHigh, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      violet: Color.lerp(violet, other.violet, t)!,
      heroGradient: t < 0.5 ? heroGradient : other.heroGradient,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}

extension AppTokensX on BuildContext {
  AppTokens get tokens =>
      Theme.of(this).extension<AppTokens>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? AppTokens.dark
          : AppTokens.light);
}
