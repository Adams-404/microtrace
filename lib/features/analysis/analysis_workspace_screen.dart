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
import '../../shared/models/microscopy_image.dart';
import '../../shared/models/session.dart';
import '../../shared/services/mock_inference_service.dart';
import '../../shared/services/model_repository.dart';
import '../../shared/services/session_repository.dart';

class AnalysisWorkspaceScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final String imageId;

  const AnalysisWorkspaceScreen({
    super.key,
    required this.sessionId,
    required this.imageId,
  });

  @override
  ConsumerState<AnalysisWorkspaceScreen> createState() =>
      _AnalysisWorkspaceScreenState();
}

class _AnalysisWorkspaceScreenState
    extends ConsumerState<AnalysisWorkspaceScreen> {
  final _inferenceService = MockLiteRTInferenceService();

  bool _isAnalyzing = false;
  double _progress = 0.0;
  String _currentStepDescription = 'Ready to initialize LiteRT pipeline.';
  AnalysisRun? _completedRun;

  Future<void> _startInference(
    MicroscopyImage image,
    MicroscopySession session,
  ) async {
    setState(() {
      _isAnalyzing = true;
      _progress = 0.05;
      _currentStepDescription =
          'Allocating LiteRT neural delegate in background isolate...';
    });

    final modelState = ref.read(modelRepositoryProvider);
    final module = modelState.modules.firstWhere(
      (m) => m.id == session.moduleId,
      orElse: () => modelState.modules.first,
    );

    final result = await _inferenceService.runInference(
      image: image,
      module: module,
      onProgress: (p, desc) {
        if (mounted) {
          setState(() {
            _progress = p;
            _currentStepDescription = desc;
          });
        }
      },
    );

    if (mounted) {
      ref
          .read(sessionRepositoryProvider.notifier)
          .updateAnalysisResult(
            sessionId: session.id,
            imageId: image.id,
            run: result,
          );

      setState(() {
        _isAnalyzing = false;
        _completedRun = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(sessionRepositoryProvider);
    final session = sessions.firstWhere((s) => s.id == widget.sessionId);
    final image = session.images.firstWhere((img) => img.id == widget.imageId);

    final modelState = ref.watch(modelRepositoryProvider);
    final module = modelState.modules.firstWhere(
      (m) => m.id == session.moduleId,
      orElse: () => modelState.modules.first,
    );
    final model = modelState.models.firstWhere(
      (m) => m.moduleId == module.id,
      orElse: () => modelState.models.first,
    );

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final activeRun = _completedRun ?? image.analysisRun;

    return Scaffold(
      appBar: ScientificAppBar(
        title: 'Analysis Workspace',
        subtitle: '${session.specimenCode} • Field #${image.fieldIndex}',
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          32 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          // Target Field Thumbnail & Specimen Summary
          ScientificCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    image.assetPath,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'FIELD #${image.fieldIndex}',
                            style: AppTypography.technicalMono(
                              AppColors.signal,
                              fontSize: 12,
                              weight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          StatusBadge(
                            label: image.qualityMetrics.isPassed
                                ? 'QUALITY OK'
                                : 'QUALITY WARNING',
                            type: image.qualityMetrics.isPassed
                                ? BadgeType.pass
                                : BadgeType.warning,
                            isCompact: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.title,
                        style: AppTypography.title(textPrimary)
                            .copyWith(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        image.captureProfile,
                        style: AppTypography.caption(textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Inference Model Architecture Info
          ScientificCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TARGET ON-DEVICE MODEL',
                      style: AppTypography.label(textSecondary),
                    ),
                    const StatusBadge(
                      label: 'OFFLINE LITERt',
                      type: BadgeType.pass,
                      icon: Icons.offline_bolt_outlined,
                      isCompact: true,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(model.name, style: AppTypography.title(textPrimary)),
                const SizedBox(height: 4),
                Text(
                  'Runtime: ${model.runtime}',
                  style: AppTypography.caption(textSecondary),
                ),
                Text(
                  'Trained on: ${module.datasetReference}',
                  style: AppTypography.caption(textSecondary),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
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
                        'INPUT: ${model.inputDimensions}',
                        style: AppTypography.technicalMono(
                          textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
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
                        'SIZE: ${Formatters.formatBytes(model.sizeBytes)}',
                        style: AppTypography.technicalMono(
                          textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Execution Progress / Analysis Engine Status
          ScientificCard(
            padding: const EdgeInsets.all(18),
            backgroundColor: _isAnalyzing
                ? AppColors.signal.withOpacity(isDark ? 0.08 : 0.04)
                : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
            borderColor: _isAnalyzing ? AppColors.signal : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'EXECUTION PIPELINE',
                      style: AppTypography.label(textSecondary),
                    ),
                    Text(
                      _isAnalyzing
                          ? '${(_progress * 100).toStringAsFixed(0)}%'
                          : (activeRun != null ? 'COMPLETED' : 'IDLE'),
                      style: AppTypography.technicalMono(
                        _isAnalyzing
                            ? AppColors.signal
                            : (activeRun != null
                                  ? AppColors.passGreen
                                  : textSecondary),
                        fontSize: 12,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: _isAnalyzing
                      ? _progress
                      : (activeRun != null ? 1.0 : 0.0),
                  backgroundColor: isDark
                      ? AppColors.darkBorder
                      : AppColors.lightBorder,
                  color: _isAnalyzing ? AppColors.signal : AppColors.passGreen,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (_isAnalyzing)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.signal,
                        ),
                      )
                    else if (activeRun != null)
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.passGreen,
                      )
                    else
                      const Icon(
                        Icons.circle_outlined,
                        size: 16,
                        color: AppColors.lightTextMuted,
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isAnalyzing
                            ? _currentStepDescription
                            : (activeRun != null
                                  ? 'Inference completed in ${activeRun.processingMs} ms. Output ready for review.'
                                  : 'Press execute to run local neural inference.'),
                        style: AppTypography.caption(textPrimary)
                            .copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Results Preview if Available
          if (activeRun != null) ...[
            ScientificCard(
              padding: const EdgeInsets.all(16),
              borderColor: AppColors.modelPredictionPurple.withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const StatusBadge(
                        label: 'PREDICTED OBSERVATION',
                        type: BadgeType.modelPrediction,
                        icon: Icons.auto_awesome,
                      ),
                      Text(
                        Formatters.formatPercentage(
                          activeRun.topPrediction.confidence,
                        ),
                        style: AppTypography.technicalMono(
                          AppColors.modelPredictionPurple,
                          fontSize: 14,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    activeRun.topPrediction.className,
                    style: AppTypography.headline(textPrimary),
                  ),
                  Text(
                    activeRun.topPrediction.scientificName,
                    style: AppTypography.caption(AppColors.signal)
                        .copyWith(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activeRun.topPrediction.morphologicalFeatures,
                    style: AppTypography.body(textSecondary)
                        .copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      context.push(
                        '/session/${session.id}/image/${image.id}/results',
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.signalDeep,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.verified_outlined, size: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'OPEN SCIENTIFIC REVIEW & SIGN-OFF',
                              style: AppTypography.technicalMono(
                                Colors.white,
                                fontSize: 12,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            FilledButton(
              onPressed: _isAnalyzing
                  ? null
                  : () => _startInference(image, session),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.signalDeep,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'EXECUTE ON-DEVICE MODEL INFERENCE',
                        style: AppTypography.technicalMono(
                          Colors.white,
                          fontSize: 13,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Decision-Support Boundary Notice
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber,
                  size: 16,
                  color: AppColors.modelPredictionPurple,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'SIMULATED PREDICTION ENGINE: Outputs represent model hypotheses derived from research benchmarks. '
                    'All findings must be confirmed by an authorized microscopist before export.',
                    style: AppTypography.caption(textSecondary)
                        .copyWith(fontSize: 11),
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
