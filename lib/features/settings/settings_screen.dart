import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/theme_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
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
          Text(
            'OPTICAL WORKSTATION THEME',
            style: AppTypography.label(textSecondary),
          ),
          const SizedBox(height: 10),

          ScientificCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildThemeOption(
                  context: context,
                  ref: ref,
                  title: 'Dark Scientific Workstation',
                  subtitle:
                      'High contrast dark slate optimized for microscopy labs',
                  icon: Icons.dark_mode_outlined,
                  mode: AppThemeMode.dark,
                  current: currentTheme,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const Divider(),
                _buildThemeOption(
                  context: context,
                  ref: ref,
                  title: 'AMOLED Pure Black (True 0x000000)',
                  subtitle: 'Zero backlight emission for darkroom fluorescence & oil immersion',
                  icon: Icons.brightness_2_outlined,
                  mode: AppThemeMode.amoled,
                  current: currentTheme,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                const Divider(),
                _buildThemeOption(
                  context: context,
                  ref: ref,
                  title: 'Light Laboratory Daylight',
                  subtitle: 'Clean neutral daylight surface for bright laboratory benches',
                  icon: Icons.light_mode_outlined,
                  mode: AppThemeMode.light,
                  current: currentTheme,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
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
                        AppColors.cyan,
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

  Widget _buildThemeOption({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String subtitle,
    required IconData icon,
    required AppThemeMode mode,
    required AppThemeMode current,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final isSelected = current == mode;
    return InkWell(
      onTap: () {
        ref.read(themeModeProvider.notifier).setTheme(mode);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.cyan : textSecondary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium(
                      isSelected ? AppColors.cyan : textPrimary,
                    ),
                  ),
                  Text(subtitle, style: AppTypography.caption(textSecondary)),
                ],
              ),
            ),
            Radio<AppThemeMode>(
              value: mode,
              groupValue: current,
              activeColor: AppColors.cyan,
              onChanged: (val) {
                if (val != null)
                  ref.read(themeModeProvider.notifier).setTheme(val);
              },
            ),
          ],
        ),
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
