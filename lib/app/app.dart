import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

class MicrotraceApp extends ConsumerWidget {
  const MicrotraceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    ThemeData selectedTheme;
    switch (themeMode) {
      case AppThemeMode.light:
        selectedTheme = AppTheme.lightTheme;
        break;
      case AppThemeMode.dark:
        selectedTheme = AppTheme.darkTheme;
        break;
      case AppThemeMode.amoled:
        selectedTheme = AppTheme.amoledTheme;
        break;
    }

    return MaterialApp.router(
      title: 'MICROTRACE',
      debugShowCheckedModeBanner: false,
      theme: selectedTheme,
      routerConfig: router,
    );
  }
}
