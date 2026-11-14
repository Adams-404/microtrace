import 'package:flutter/material.dart';

/// Scientific color palette for MICROTRACE workstation.
/// Prioritizes high optical legibility, darkroom laboratory usability,
/// and distinct semantic channels for observations vs model predictions.
class AppColors {
  // Scientific Brand Accents
  static const Color cyan = Color(0xFF0EA5E9); // Sky / Cerulean
  static const Color cyanDark = Color(0xFF0284C7);
  static const Color cobalt = Color(0xFF2563EB);
  static const Color teal = Color(0xFF14B8A6);

  // Optical & Laboratory Semantics
  static const Color passGreen = Color(0xFF10B981);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color dangerRose = Color(0xFFF43F5E);
  static const Color modelPredictionPurple = Color(0xFF8B5CF6);
  static const Color observationBlue = Color(0xFF0284C7);

  // Light Theme Surfaces
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderStrong = Color(0xFFCBD5E1);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Dark Theme Surfaces (Lab Slate)
  static const Color darkBg = Color(0xFF0B0F17);
  static const Color darkSurface = Color(0xFF131B26);
  static const Color darkSurfaceSubtle = Color(0xFF1A2433);
  static const Color darkBorder = Color(0xFF243042);
  static const Color darkBorderStrong = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // AMOLED Theme Surfaces (True Black 0x000000 for pure darkroom microscopy)
  static const Color amoledBg = Color(0xFF000000);
  static const Color amoledSurface = Color(0xFF0D0D0E);
  static const Color amoledSurfaceSubtle = Color(0xFF161719);
  static const Color amoledBorder = Color(0xFF27272A);
  static const Color amoledBorderStrong = Color(0xFF3F3F46);
  static const Color amoledTextPrimary = Color(0xFFFAFAFA);
  static const Color amoledTextSecondary = Color(0xFFA1A1AA);
  static const Color amoledTextMuted = Color(0xFF71717A);
}
