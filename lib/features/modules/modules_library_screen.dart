import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/widgets/scientific_app_bar.dart';
import '../../core/widgets/scientific_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/services/model_repository.dart';

class ModulesLibraryScreen extends ConsumerWidget {
  const ModulesLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modelState = ref.watch(modelRepositoryProvider);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: ScientificAppBar(
        title: 'Module Library',
        subtitle: 'MODULAR COMPUTER-VISION EXTENSIONS',
        actions: [
          TextButton(
            onPressed: () => context.push('/models'),
            child: Text(
              'MODELS',
              style: AppTypography.technicalMono(
                AppColors.cyan,
                fontSize: 11,
                weight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Platform Architecture Intro
          ScientificCard(
            backgroundColor: isDark
                ? AppColors.darkSurfaceSubtle
                : AppColors.lightSurfaceSubtle,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.extension_outlined,
                  color: AppColors.cyan,
                  size: 28,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ONE PLATFORM, SPECIALIZED MODULES',
                        style: AppTypography.label(textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'MICROTRACE is designed as a modular microscopy platform. '
                        'Each module defines its specific staining protocol, target magnification, and validated model architecture.',
                        style: AppTypography.caption(textSecondary)
                            .copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text('ANALYSIS MODULES', style: AppTypography.label(textSecondary)),
          const SizedBox(height: 10),

          for (final module in modelState.modules) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: ScientificCard(
                padding: const EdgeInsets.all(18),
                borderColor: module.isAvailable
                    ? AppColors.cyan.withOpacity(0.4)
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                module.category.toUpperCase(),
                                style: AppTypography.technicalMono(
                                  AppColors.cyan,
                                  fontSize: 10,
                                  weight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                module.name,
                                style: AppTypography.title(textPrimary)
                                    .copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        StatusBadge(
                          label: module.isAvailable ? 'READY' : 'ROADMAP',
                          type: module.isAvailable
                              ? BadgeType.pass
                              : BadgeType.neutral,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      module.fullDescription,
                      style: AppTypography.body(textSecondary)
                          .copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 14),
                    const Divider(),
                    const SizedBox(height: 10),

                    // Specs & Specimen protocols
                    Text(
                      'SUPPORTED PREPARATIONS:',
                      style: AppTypography.label(textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: module.supportedSpecimens.map((spec) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurfaceSubtle
                                : AppColors.lightSurfaceSubtle,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                          ),
                          child: Text(
                            spec,
                            style: AppTypography.caption(textPrimary)
                                .copyWith(fontSize: 11),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Objective: ${module.recommendedMagnification}',
                          style: AppTypography.caption(textSecondary),
                        ),
                        Text(
                          'Version: ${module.version}',
                          style: AppTypography.technicalMono(
                            textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
