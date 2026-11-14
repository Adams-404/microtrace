import 'package:flutter/services.dart';

/// Central haptic vocabulary. Every meaningful interaction should use one of
/// these so the app feels physical on device. No-ops on web/desktop.
class Haptics {
  Haptics._();

  /// Light tap for buttons, cards, icons and navigation.
  static void tap() {
    HapticFeedback.lightImpact();
  }

  /// Selection change: tabs, chips, theme, segmented controls.
  static void select() {
    HapticFeedback.selectionClick();
  }

  /// Completed action: analysis finished, capture stored, model installed.
  static void success() {
    HapticFeedback.mediumImpact();
  }

  /// Destructive or failed action.
  static void warning() {
    HapticFeedback.heavyImpact();
  }
}
