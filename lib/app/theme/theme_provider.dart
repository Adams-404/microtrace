import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, AppThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<AppThemeMode> {
  static const _prefKey = 'microtrace_theme_mode';

  @override
  AppThemeMode build() {
    _loadFromPrefs();
    return AppThemeMode.dark; // Default to dark scientific workstation
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final index = prefs.getInt(_prefKey);
      if (index != null && index >= 0 && index < AppThemeMode.values.length) {
        state = AppThemeMode.values[index];
      }
    } catch (_) {
      // fallback to state
    }
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefKey, mode.index);
    } catch (_) {}
  }
}
