import 'package:flutter/material.dart';

/// MICROTRACE instrument palette.
///
/// A near-black, blue-shifted "darkroom" system with a single luminous azure
/// brand channel derived from the reticle mark, plus disciplined semantic
/// accents for observation vs. model-prediction data.
class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color cyan = Color(0xFF4CC9F0); // Reticle azure
  static const Color cyanDark = Color(0xFF0EA5E9);
  static const Color cyanDeep = Color(0xFF0284C7);
  static const Color teal = Color(0xFF2DD4BF);
  static const Color cobalt = Color(0xFF6366F1);

  // ── Semantic channels ────────────────────────────────────────────────────
  static const Color passGreen = Color(0xFF34D399);
  static const Color warningAmber = Color(0xFFFBBF24);
  static const Color dangerRose = Color(0xFFFB7185);
  static const Color modelPredictionPurple = Color(0xFFA78BFA);
  static const Color observationBlue = Color(0xFF60A5FA);

  // ── Light surfaces ("daylight bench") ────────────────────────────────────
  static const Color lightBg = Color(0xFFF5F7FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFEEF2F8);
  static const Color lightSurfaceHigh = Color(0xFFE7EDF6);
  static const Color lightBorder = Color(0xFFE2E8F2);
  static const Color lightBorderStrong = Color(0xFFCBD5E1);
  static const Color lightTextPrimary = Color(0xFF0B1220);
  static const Color lightTextSecondary = Color(0xFF52627A);
  static const Color lightTextMuted = Color(0xFF8A97AB);

  // ── Dark surfaces ("darkroom") ───────────────────────────────────────────
  static const Color darkBg = Color(0xFF06080D);
  static const Color darkSurface = Color(0xFF0D121B);
  static const Color darkSurfaceSubtle = Color(0xFF131A25);
  static const Color darkSurfaceHigh = Color(0xFF182131);
  static const Color darkBorder = Color(0xFF1E2836);
  static const Color darkBorderStrong = Color(0xFF2C394C);
  static const Color darkTextPrimary = Color(0xFFF2F6FC);
  static const Color darkTextSecondary = Color(0xFF9BA9BD);
  static const Color darkTextMuted = Color(0xFF64748B);

  // ── AMOLED surfaces (true black darkroom) ────────────────────────────────
  static const Color amoledBg = Color(0xFF000000);
  static const Color amoledSurface = Color(0xFF08090B);
  static const Color amoledSurfaceSubtle = Color(0xFF101114);
  static const Color amoledSurfaceHigh = Color(0xFF16181C);
  static const Color amoledBorder = Color(0xFF22242A);
  static const Color amoledBorderStrong = Color(0xFF34373F);
  static const Color amoledTextPrimary = Color(0xFFFAFAFA);
  static const Color amoledTextSecondary = Color(0xFFA1A1AA);
  static const Color amoledTextMuted = Color(0xFF71717A);

  // ── Ready-made gradients ─────────────────────────────────────────────────
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4CC9F0), Color(0xFF2DD4BF)],
  );

  static const LinearGradient heroGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B3A4E), Color(0xFF0A2530), Color(0xFF0D121B)],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient heroGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFDDF6FF), Color(0xFFE9FBF7), Color(0xFFFFFFFF)],
  );
}
