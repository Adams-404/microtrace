import 'package:flutter/material.dart';

/// Instrument typography: Inter for interface text, JetBrains Mono for
/// machine-readable values (specimen codes, metrics, calibration data).
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';
  static const String monoFamily = 'JetBrains Mono';

  static const List<FontFeature> _tabular = [
    FontFeature.tabularFigures(),
    FontFeature.enable('ss01'),
  ];

  static TextStyle display(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.1,
    color: color,
    fontFeatures: _tabular,
  );

  static TextStyle headline(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.18,
    color: color,
    fontFeatures: _tabular,
  );

  static TextStyle title(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.5,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.25,
    color: color,
  );

  static TextStyle body(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.55,
    color: color,
  );

  static TextStyle bodyMedium(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: color,
  );

  static TextStyle caption(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.05,
    height: 1.4,
    color: color,
  );

  /// Uppercase section eyebrow.
  static TextStyle label(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.3,
    height: 1.2,
    color: color,
  );

  /// Large numeric readout for dashboards.
  static TextStyle number(Color color, {double fontSize = 22}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    height: 1.05,
    color: color,
    fontFeatures: _tabular,
  );

  static TextStyle technicalMono(
    Color color, {
    double fontSize = 12,
    FontWeight weight = FontWeight.w500,
  }) => TextStyle(
    fontFamily: monoFamily,
    fontSize: fontSize,
    fontWeight: weight,
    letterSpacing: 0.2,
    height: 1.3,
    color: color,
    fontFeatures: _tabular,
  );

  static TextTheme textTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: display(primary),
      displayMedium: display(primary).copyWith(fontSize: 28),
      displaySmall: display(primary).copyWith(fontSize: 24),
      headlineLarge: headline(primary),
      headlineMedium: headline(primary).copyWith(fontSize: 21),
      headlineSmall: title(primary).copyWith(fontSize: 18),
      titleLarge: title(primary).copyWith(fontSize: 18),
      titleMedium: title(primary),
      titleSmall: title(primary).copyWith(fontSize: 14),
      bodyLarge: body(primary).copyWith(fontSize: 15),
      bodyMedium: body(primary),
      bodySmall: caption(secondary),
      labelLarge: bodyMedium(primary).copyWith(fontSize: 13),
      labelMedium: label(secondary),
      labelSmall: label(secondary).copyWith(fontSize: 10),
    );
  }
}
