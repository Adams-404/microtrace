import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/app_tokens.dart';
import 'theme/theme_provider.dart';

class MicrotraceApp extends ConsumerWidget {
  const MicrotraceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'MICROTRACE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.forMode(themeMode),
      themeAnimationDuration: const Duration(milliseconds: 280),
      themeAnimationCurve: Curves.easeOutCubic,
      routerConfig: router,
      builder: (context, child) {
        final t = context.tokens;
        final size = MediaQuery.sizeOf(context);
        final isWide = size.width > 760;

        return ColoredBox(
          color: isWide
              ? Color.alphaBlend(
                  Colors.black.withValues(alpha: t.isDark ? 0.45 : 0.06),
                  t.bg,
                )
              : t.bg,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              constraints: const BoxConstraints(maxWidth: 680),
              decoration: isWide
                  ? BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(color: t.border),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: t.isDark ? 0.5 : 0.08,
                          ),
                          blurRadius: 60,
                          spreadRadius: -10,
                        ),
                      ],
                    )
                  : null,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
