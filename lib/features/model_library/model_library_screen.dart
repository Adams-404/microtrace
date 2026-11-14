import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/metric_tile.dart';
import '../../core/widgets/scientific_app_bar.dart';
import '../../core/widgets/scientific_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/services/model_repository.dart';

class ModelLibraryScreen extends ConsumerWidget {
  const ModelLibraryScreen({super.key});

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

    final installedCount = modelState.models.where((m) => m.isInstalled).length;
    final totalSize = modelState.models
        .where((m) => m.isInstalled)
        .fold<int>(0, (sum, m) => sum + m.sizeBytes);

    return Scaffold(
      appBar: const ScientificAppBar(
        title: 'Model Library',
        subtitle: 'LITERT NEURAL RUNTIME MANAGEMENT',
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          32 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          // Storage Overview Row
          Row(
            children: [
              Expanded(
                child: MetricTile(
                  label: 'Installed Models',
                  value: '$installedCount',
                  subtitle: 'On-device runtimes',
                  icon: Icons.memory,
                  accentColor: AppColors.signal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricTile(
                  label: 'Model Storage',
                  value: Formatters.formatBytes(totalSize),
                  subtitle: 'App-private storage',
                  icon: Icons.storage,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            'ON-DEVICE NEURAL MODELS',
            style: AppTypography.label(textSecondary),
          ),
          const SizedBox(height: 10),

          for (final model in modelState.models) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ScientificCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.name,
                                style: AppTypography.title(textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Version ${model.version} • ${Formatters.formatBytes(model.sizeBytes)}',
                                style: AppTypography.caption(textSecondary),
                              ),
                            ],
                          ),
                        ),
                        StatusBadge(
                          label: model.isInstalled ? 'INSTALLED' : 'AVAILABLE',
                          type: model.isInstalled
                              ? BadgeType.pass
                              : BadgeType.neutral,
                          icon: model.isInstalled
                              ? Icons.check_circle_outline
                              : Icons.cloud_download_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Runtime: ${model.runtime}',
                      style: AppTypography.caption(textSecondary),
                    ),
                    Text(
                      'Input Tensor: ${model.inputDimensions}',
                      style: AppTypography.caption(textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      model.accuracyReport,
                      style: AppTypography.caption(textPrimary)
                          .copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceSubtle
                            : AppColors.lightSurfaceSubtle,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'SHA256: ${model.sha256Checksum}',
                        style: AppTypography.technicalMono(
                          textSecondary,
                          fontSize: 9,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (model.isInstalled) ...[
                          OutlinedButton(
                            onPressed: () {
                              ref
                                  .read(modelRepositoryProvider.notifier)
                                  .updateModel(model.modelId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Checking checksum for ${model.name}... Updated to latest verified build.',
                                  ),
                                  backgroundColor: AppColors.passGreen,
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                            ),
                            child: const Text('CHECK UPDATE'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(modelRepositoryProvider.notifier)
                                  .toggleModelInstallation(model.modelId);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.dangerRose,
                            ),
                            child: const Text('UNINSTALL'),
                          ),
                        ] else ...[
                          FilledButton(
                            onPressed: () {
                              ref
                                  .read(modelRepositoryProvider.notifier)
                                  .toggleModelInstallation(model.modelId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Model ${model.name} installed locally.',
                                  ),
                                  backgroundColor: AppColors.passGreen,
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.signalDeep,
                            ),
                            child: const Text('INSTALL OFFLINE'),
                          ),
                        ],
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
