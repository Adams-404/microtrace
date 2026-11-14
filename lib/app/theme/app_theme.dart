import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_tokens.dart';
import 'app_typography.dart';

enum AppThemeMode { light, dark, amoled }

class AppTheme {
  AppTheme._();

  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 26;

  static ThemeData get darkTheme => _build(AppTokens.dark, AppColors.darkBg);

  static ThemeData get amoledTheme => _build(AppTokens.amoled, AppColors.amoledBg);

  static ThemeData get lightTheme => _build(AppTokens.light, AppColors.lightBg);

  /// Kept for callers that pick a theme dynamically.
  static ThemeData forMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return lightTheme;
      case AppThemeMode.dark:
        return darkTheme;
      case AppThemeMode.amoled:
        return amoledTheme;
    }
  }

  static ThemeData _build(AppTokens t, Color background) {
    final colorScheme = ColorScheme(
      brightness: t.isDark ? Brightness.dark : Brightness.light,
      primary: t.accent,
      onPrimary: t.onAccent,
      primaryContainer: t.accentSoft,
      onPrimaryContainer: t.accent,
      secondary: AppColors.teal,
      onSecondary: t.onAccent,
      secondaryContainer: t.accentSoft,
      onSecondaryContainer: t.textPrimary,
      tertiary: t.violet,
      onTertiary: t.onAccent,
      error: t.danger,
      onError: t.isDark ? const Color(0xFF2A0A10) : Colors.white,
      surface: t.surface,
      onSurface: t.textPrimary,
      surfaceContainerLowest: background,
      surfaceContainerLow: t.surface,
      surfaceContainer: t.surface,
      surfaceContainerHigh: t.surfaceHigh,
      surfaceContainerHighest: t.surfaceHigh,
      onSurfaceVariant: t.textSecondary,
      outline: t.borderStrong,
      outlineVariant: t.border,
      inverseSurface: t.textPrimary,
      onInverseSurface: t.surface,
      shadow: Colors.black,
      scrim: Colors.black,
    );

    const transitions = PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
      },
    );

    return ThemeData(
      useMaterial3: true,
      brightness: t.isDark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      cardColor: t.surface,
      dividerColor: t.border,
      fontFamily: AppTypography.fontFamily,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      pageTransitionsTheme: transitions,
      extensions: <ThemeExtension<dynamic>>[t],
      textTheme: AppTypography.textTheme(t.textPrimary, t.textSecondary),
      primaryTextTheme: AppTypography.textTheme(t.textPrimary, t.textSecondary),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: t.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        toolbarHeight: 64,
        iconTheme: IconThemeData(color: t.textPrimary, size: 22),
        actionsIconTheme: IconThemeData(color: t.textSecondary, size: 22),
        titleTextStyle: AppTypography.title(t.textPrimary),
        systemOverlayStyle: t.isDark
            ? SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: background,
                systemNavigationBarIconBrightness: Brightness.light,
              )
            : SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
                systemNavigationBarColor: background,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
      ),

      cardTheme: CardThemeData(
        color: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(color: t.border, width: 1),
        ),
      ),

      iconTheme: IconThemeData(color: t.textSecondary, size: 22),

      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(t.textSecondary),
          overlayColor: WidgetStatePropertyAll(t.accentSoft),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: t.accent,
          foregroundColor: t.onAccent,
          disabledBackgroundColor: t.surfaceHigh,
          disabledForegroundColor: t.textMuted,
          elevation: 0,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: AppTypography.bodyMedium(t.onAccent).copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: t.accent,
          foregroundColor: t.onAccent,
          elevation: 0,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: AppTypography.bodyMedium(t.onAccent)
              .copyWith(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: t.textPrimary,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: BorderSide(color: t.borderStrong),
          textStyle: AppTypography.bodyMedium(t.textPrimary)
              .copyWith(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: t.accent,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          textStyle: AppTypography.bodyMedium(t.accent)
              .copyWith(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.surfaceHigh,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        hintStyle: AppTypography.body(t.textMuted),
        labelStyle: AppTypography.caption(t.textSecondary),
        helperStyle: AppTypography.caption(t.textMuted),
        errorStyle: AppTypography.caption(t.danger),
        prefixIconColor: t.textMuted,
        suffixIconColor: t.textMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: t.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: t.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: t.accent, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: t.danger.withValues(alpha: 0.7)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: t.danger, width: 1.6),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: t.border,
        thickness: 1,
        space: 1,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: t.surfaceHigh,
        selectedColor: t.accentSoft,
        disabledColor: t.surface,
        side: BorderSide(color: t.border),
        shape: const StadiumBorder(),
        labelStyle: AppTypography.caption(t.textSecondary),
        secondaryLabelStyle: AppTypography.caption(t.accent),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        showCheckmark: false,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: t.surfaceHigh,
        contentTextStyle: AppTypography.body(t.textPrimary),
        actionTextColor: t.accent,
        elevation: 0,
        insetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: BorderSide(color: t.border),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXl),
          side: BorderSide(color: t.border),
        ),
        titleTextStyle: AppTypography.headline(t.textPrimary)
            .copyWith(fontSize: 20),
        contentTextStyle: AppTypography.body(t.textSecondary),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: t.surface,
        modalBackgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        showDragHandle: true,
        dragHandleColor: t.borderStrong,
        dragHandleSize: const Size(40, 4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: t.accent,
        linearTrackColor: t.surfaceHigh,
        circularTrackColor: t.surfaceHigh,
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: t.accent,
        inactiveTrackColor: t.surfaceHigh,
        thumbColor: t.accent,
        overlayColor: t.accentSoft,
        trackHeight: 4,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.onAccent : t.textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.accent : t.surfaceHigh,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.accent : t.borderStrong,
        ),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.accent : t.textMuted,
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.accent : Colors.transparent,
        ),
        checkColor: WidgetStatePropertyAll(t.onAccent),
        side: BorderSide(color: t.borderStrong, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: t.surfaceHigh,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: t.border),
        ),
        textStyle: AppTypography.caption(t.textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: t.textSecondary,
        textColor: t.textPrimary,
        subtitleTextStyle: AppTypography.caption(t.textSecondary),
        titleTextStyle: AppTypography.title(t.textPrimary)
            .copyWith(fontSize: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: t.accent,
        selectionColor: t.accent.withValues(alpha: 0.25),
        selectionHandleColor: t.accent,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: t.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: t.accentSoft,
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStatePropertyAll(
          AppTypography.caption(t.textSecondary).copyWith(fontSize: 11),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(
            size: 22,
            color: s.contains(WidgetState.selected) ? t.accent : t.textMuted,
          ),
        ),
      ),
    );
  }
}
