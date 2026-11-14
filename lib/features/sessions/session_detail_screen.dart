import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/scientific_app_bar.dart';
import '../../core/widgets/scientific_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/analysis_run.dart';
import '../../shared/models/session.dart';
import '../../shared/services/session_repository.dart';

class SessionDetailScreen extends ConsumerWidget {
  final String sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionRepositoryProvider);
    final session = sessions.firstWhere(
      (s) => s.id == sessionId,
      orElse: () => throw Exception('Session not found'),
    );

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
        title: session.specimenCode,
        subtitle: session.title,
        actions: [
          IconButton(
            tooltip: 'Export Session Report',
            icon: const Icon(
              Icons.picture_as_pdf_outlined,
              color: AppColors.signal,
              size: 20,
            ),
            onPressed: () => context.push('/session/${session.id}/report'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Specimen Metadata Card
          ScientificCard(
            padding: const EdgeInsets.all(16),
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
                            AppColors.signal,
                            fontSize: 14,
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
                        ),
                      ],
                    ),
                    Text(
                      Formatters.formatDateTime(session.createdAt),
                      style: AppTypography.caption(textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(session.title, style: AppTypography.headline(textPrimary)),
                const SizedBox(height: 6),
                Text(
                  'Preparation: ${session.specimenType}',
                  style: AppTypography.body(textSecondary)
                      .copyWith(fontSize: 13),
                ),
                Text(
                  'Optical Profile: ${session.captureProfile}',
                  style: AppTypography.body(textSecondary)
                      .copyWith(fontSize: 13),
                ),
                Text(
                  'Operator: ${session.operatorLabel}',
                  style: AppTypography.body(textSecondary)
                      .copyWith(fontSize: 13),
                ),
                if (session.notes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Notes: ${session.notes}',
                    style: AppTypography.caption(textSecondary)
                        .copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Actions Row
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.push('/capture/${session.id}'),
                  icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                  label: const Text('ACQUIRE FIELDS'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.signalDeep,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      context.push('/session/${session.id}/report'),
                  icon: const Icon(
                    Icons.assessment_outlined,
                    size: 18,
                    color: AppColors.signal,
                  ),
                  label: Text(
                    'VIEW REPORT',
                    style: AppTypography.technicalMono(
                      AppColors.signal,
                      fontSize: 11,
                      weight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: AppColors.signal.withOpacity(0.5)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Captured Fields Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MICROSCOPIC FIELDS (${session.images.length})',
                style: AppTypography.label(textSecondary),
              ),
              Text(
                'TAP FIELD TO REVIEW',
                style: AppTypography.technicalMono(
                  AppColors.signal,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (session.images.isEmpty)
            ScientificCard(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: textSecondary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No fields captured yet',
                        style: AppTypography.body(textPrimary),
                      ),
                      const SizedBox(height: 6),
                      FilledButton(
                        onPressed: () => context.push('/capture/${session.id}'),
                        child: const Text('OPEN CAPTURE WORKSPACE'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: session.images.length,
              itemBuilder: (context, index) {
                final image = session.images[index];
                final run = image.analysisRun;
                return ScientificCard(
                  onTap: () =>
                      context.push('/session/${session.id}/image/${image.id}'),
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(9),
                              ),
                              child: Image.asset(
                                image.assetPath,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 6,
                              left: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '#${image.fieldIndex}',
                                  style: AppTypography.technicalMono(
                                    Colors.white,
                                    fontSize: 10,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: StatusBadge(
                                label: image.qualityMetrics.isPassed
                                    ? 'PASS'
                                    : 'WARN',
                                type: image.qualityMetrics.isPassed
                                    ? BadgeType.pass
                                    : BadgeType.warning,
                                isCompact: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              run != null
                                  ? (run.correctedClass ??
                                        run.topPrediction.className)
                                  : 'Analysis Pending',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.body(textPrimary).copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              run != null
                                  ? '${run.reviewStatus.displayName} (${Formatters.formatPercentage(run.topPrediction.confidence)})'
                                  : 'Focus: ${image.qualityMetrics.laplacianSharpness.toStringAsFixed(0)}',
                              style: AppTypography.technicalMono(
                                run != null
                                    ? AppColors.modelPredictionPurple
                                    : textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
