import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/theme_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/metric_tile.dart';
import '../../core/widgets/scientific_app_bar.dart';
import '../../core/widgets/scientific_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/analysis_run.dart';
import '../../shared/models/session.dart';
import '../../shared/services/session_repository.dart';
import '../../shared/services/storage_service.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionRepositoryProvider);
    final storage = ref.watch(storageServiceProvider);
    final currentTheme = ref.watch(themeModeProvider);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    // Derived statistics
    final totalFields = sessions.fold<int>(
      0,
      (sum, s) => sum + s.images.length,
    );
    final pendingReviews = sessions.fold<int>(
      0,
      (sum, s) =>
          sum +
          s.images
              .where(
                (img) => img.analysisRun?.reviewStatus == ReviewStatus.pending,
              )
              .length,
    );

    return Scaffold(
      appBar: ScientificAppBar(
        title: AppConstants.appName,
        subtitle: 'PORTABLE OPTICAL MICROSCOPY WORKSTATION',
        actions: [
          IconButton(
            tooltip: 'Toggle Theme (Light / Dark / AMOLED)',
            icon: Icon(
              currentTheme == AppThemeMode.light
                  ? Icons.light_mode
                  : (currentTheme == AppThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.brightness_2),
              size: 20,
            ),
            onPressed: () {
              final nextIndex =
                  (currentTheme.index + 1) % AppThemeMode.values.length;
              ref
                  .read(themeModeProvider.notifier)
                  .setTheme(AppThemeMode.values[nextIndex]);
            },
          ),
          IconButton(
            tooltip: 'Workstation Settings',
            icon: const Icon(Icons.tune, size: 20),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // Primary Action: Start Session
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0C4A6E), const Color(0xFF0369A1)]
                    : [const Color(0xFFE0F2FE), const Color(0xFFBAE6FD)],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cyan.withOpacity(0.4)),
            ),
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const StatusBadge(
                            label: 'OPTICAL ADAPTER READY',
                            type: BadgeType.pass,
                            icon: Icons.check_circle_outline,
                            isCompact: true,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'FIELD LAB MODE',
                            style: AppTypography.technicalMono(
                              isDark
                                  ? Colors.white70
                                  : AppColors.lightTextSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Start Microscopy Session',
                        style: AppTypography.headline(
                          isDark ? Colors.white : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mount phone adapter to eyepiece, configure slide metadata, and acquire calibrated fields.',
                        style: AppTypography.body(
                          isDark
                              ? Colors.white70
                              : AppColors.lightTextSecondary,
                        ).copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                ElevatedButton(
                  onPressed: () => context.push('/new-session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cyan,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_a_photo_outlined, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'NEW SESSION',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Workspace Telemetry Grid
          Row(
            children: [
              Expanded(
                child: MetricTile(
                  label: 'Sessions',
                  value: '${sessions.length}',
                  subtitle: 'Logged offline',
                  icon: Icons.folder_open,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricTile(
                  label: 'Fields',
                  value: '$totalFields',
                  subtitle: 'Microscopic images',
                  icon: Icons.filter_center_focus,
                  accentColor: AppColors.cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MetricTile(
                  label: 'Pending Reviews',
                  value: '$pendingReviews',
                  subtitle: 'Awaiting human sign-off',
                  icon: Icons.rate_review_outlined,
                  accentColor: pendingReviews > 0
                      ? AppColors.warningAmber
                      : AppColors.passGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricTile(
                  label: 'Local Storage',
                  value: Formatters.formatBytes(storage.totalBytes),
                  subtitle: 'Images & models',
                  icon: Icons.sd_storage_outlined,
                  onTap: () => context.push('/settings'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Sessions Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'RECENT SESSIONS',
                    style: AppTypography.label(textSecondary),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceSubtle
                          : AppColors.lightSurfaceSubtle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${sessions.length}',
                      style: AppTypography.technicalMono(
                        textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.push('/sessions'),
                child: Row(
                  children: [
                    Text(
                      'VIEW ALL',
                      style: AppTypography.technicalMono(
                        AppColors.cyan,
                        fontSize: 11,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: AppColors.cyan,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Recent Sessions List
          if (sessions.isEmpty)
            ScientificCard(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.biotech_outlined,
                        size: 40,
                        color: textSecondary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No microscopy sessions yet',
                        style: AppTypography.body(textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap "New Session" to start your first microscope acquisition.',
                        style: AppTypography.caption(textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            for (final session in sessions.take(3)) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ScientificCard(
                  onTap: () => context.push('/session/${session.id}'),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                session.specimenCode,
                                style: AppTypography.technicalMono(
                                  AppColors.cyan,
                                  fontSize: 13,
                                  weight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              StatusBadge(
                                label: session.status.displayName,
                                type: session.status == SessionStatus.reviewed
                                    ? BadgeType.pass
                                    : (session.status == SessionStatus.completed
                                          ? BadgeType.humanObservation
                                          : BadgeType.warning),
                                isCompact: true,
                              ),
                            ],
                          ),
                          Text(
                            Formatters.formatShortDate(session.createdAt),
                            style: AppTypography.caption(textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        session.title,
                        style: AppTypography.title(textPrimary)
                            .copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 13,
                            color: textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            session.specimenType,
                            style: AppTypography.caption(textSecondary),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.photo_library_outlined,
                            size: 13,
                            color: textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${session.images.length} fields',
                            style: AppTypography.caption(textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

          const SizedBox(height: 20),

          // Analysis Modules Preview Card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'INSTALLED MODULES & MODELS',
                style: AppTypography.label(textSecondary),
              ),
              TextButton(
                onPressed: () => context.push('/modules'),
                child: Row(
                  children: [
                    Text(
                      'CATALOG',
                      style: AppTypography.technicalMono(
                        AppColors.cyan,
                        fontSize: 11,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: AppColors.cyan,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ScientificCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.cyan.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.spa_outlined,
                        color: AppColors.cyan,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Mycology Patch Classifier',
                                style: AppTypography.title(textPrimary)
                                    .copyWith(fontSize: 15),
                              ),
                              const SizedBox(width: 8),
                              const StatusBadge(
                                label: 'READY',
                                type: BadgeType.pass,
                                isCompact: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'DeFungi 5-Class Morphology • MobileNetV3-Small LiteRT Float16',
                            style: AppTypography.caption(textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming: Parasitology, Malaria Smear, Hemocytometry',
                      style: AppTypography.caption(textSecondary)
                          .copyWith(fontSize: 11),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/models'),
                      child: Text(
                        'MANAGE MODELS',
                        style: AppTypography.technicalMono(
                          AppColors.cyan,
                          fontSize: 10,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Scientific Safety Reminder
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceSubtle
                  : AppColors.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.gavel_outlined,
                  size: 16,
                  color: AppColors.cyan,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'MICROTRACE is an offline-first research and laboratory decision-support tool. '
                    'Automated model outputs are consultative and require human microscopist verification.',
                    style: AppTypography.caption(textSecondary)
                        .copyWith(fontSize: 11, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
