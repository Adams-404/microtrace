import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../app/theme/app_tokens.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/theme_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/haptics.dart';
import '../../core/widgets/scientific_app_bar.dart';
import '../../core/widgets/scientific_card.dart';
import '../../shared/services/storage_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeModeProvider);
    final storage = ref.watch(storageServiceProvider);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: const ScientificAppBar(
        title: 'Workstation Settings',
        subtitle: 'PREFERENCES & LOCAL STORAGE',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance & Theme Section
          Text('APPEARANCE', style: AppTypography.label(textSecondary)),
          const SizedBox(height: 10),

          ScientificCard(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: _ThemeChoice(
                    label: 'Darkroom',
                    hint: 'Default',
                    mode: AppThemeMode.dark,
                    current: currentTheme,
                    swatchBg: AppColors.darkBg,
                    swatchSurface: AppColors.darkSurface,
                    onSelect: () => ref
                        .read(themeModeProvider.notifier)
                        .setTheme(AppThemeMode.dark),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _ThemeChoice(
                    label: 'AMOLED',
                    hint: 'True black',
                    mode: AppThemeMode.amoled,
                    current: currentTheme,
                    swatchBg: AppColors.amoledBg,
                    swatchSurface: AppColors.amoledSurfaceHigh,
                    onSelect: () => ref
                        .read(themeModeProvider.notifier)
                        .setTheme(AppThemeMode.amoled),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _ThemeChoice(
                    label: 'Daylight',
                    hint: 'Bright bench',
                    mode: AppThemeMode.light,
                    current: currentTheme,
                    swatchBg: AppColors.lightBg,
                    swatchSurface: AppColors.lightSurface,
                    onSelect: () => ref
                        .read(themeModeProvider.notifier)
                        .setTheme(AppThemeMode.light),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Local Storage Management
          Text(
            'LOCAL APP-PRIVATE STORAGE',
            style: AppTypography.label(textSecondary),
          ),
          const SizedBox(height: 10),

          ScientificCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Disk Footprint',
                      style: AppTypography.body(textPrimary),
                    ),
                    Text(
                      Formatters.formatBytes(storage.totalBytes),
                      style: AppTypography.technicalMono(
                        AppColors.signal,
                        fontSize: 13,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _storageRow(
                  'SQLite Database & Sessions',
                  Formatters.formatBytes(storage.databaseBytes),
                  textSecondary,
                ),
                _storageRow(
                  'Microscopy Slide Images',
                  Formatters.formatBytes(storage.rawImagesBytes),
                  textSecondary,
                ),
                _storageRow(
                  'On-Device Neural Models',
                  Formatters.formatBytes(storage.modelsBytes),
                  textSecondary,
                ),
                _storageRow(
                  'Exported PDF Reports Cache',
                  Formatters.formatBytes(storage.reportsBytes),
                  textSecondary,
                ),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: () {
                    ref
                        .read(storageServiceProvider.notifier)
                        .clearReportsCache();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reports cache purged successfully.'),
                        backgroundColor: AppColors.passGreen,
                      ),
                    );
                  },
                  child: const Text('PURGE REPORT CACHE'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Privacy & Offline Disclosure
          Text(
            'PRIVACY & OFFLINE ARCHITECTURE',
            style: AppTypography.label(textSecondary),
          ),
          const SizedBox(height: 10),

          ScientificCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppColors.passGreen,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '100% Offline-First Guarantee',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'MICROTRACE does not transmit images, patient codes, or session records over the internet. '
                  'Inference is executed completely on-device through LiteRT compiled models.',
                  style: AppTypography.body(textSecondary)
                      .copyWith(fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Scientific Disclaimer
          Text(
            'LEGAL & SCIENTIFIC NOTICE',
            style: AppTypography.label(textSecondary),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.gavel,
                  color: AppColors.warningAmber,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppConstants.scientificDisclaimer,
                    style: AppTypography.caption(textSecondary)
                        .copyWith(fontSize: 11, height: 1.5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About MICROTRACE
          Center(
            child: Column(
              children: [
                Text(
                  '${AppConstants.appName} v${AppConstants.appVersion}',
                  style: AppTypography.technicalMono(
                    textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Smartphone-Assisted Microscopy Workstation',
                  style: AppTypography.caption(textSecondary)
                      .copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _storageRow(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption(textColor)),
          Text(
            value,
            style: AppTypography.technicalMono(textColor, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ThemeChoice extends StatelessWidget {
  final String label;
  final String hint;
  final AppThemeMode mode;
  final AppThemeMode current;
  final Color swatchBg;
  final Color swatchSurface;
  final VoidCallback onSelect;

  const _ThemeChoice({
    required this.label,
    required this.hint,
    required this.mode,
    required this.current,
    required this.swatchBg,
    required this.swatchSurface,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final selected = current == mode;
    final tokens = context.tokens;
    const accent = AppColors.signal;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Haptics.select();
          onSelect();
        },
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selected
                ? accent.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? accent.withValues(alpha: 0.45)
                  : Colors.transparent,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: swatchBg,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 18,
                      height: 4,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: swatchSurface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption(
                        selected ? accent : tokens.textPrimary,
                      ).copyWith(fontWeight: FontWeight.w600, fontSize: 11.5),
                    ),
                  ),
                  if (selected)
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 13,
                      color: AppColors.signal,
                    ),
                ],
              ),
              const SizedBox(height: 1),
              Text(
                hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption(tokens.textMuted)
                    .copyWith(fontSize: 9.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
