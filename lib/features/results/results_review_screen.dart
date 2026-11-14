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
import '../../shared/services/session_repository.dart';
import 'widgets/annotation_overlay_painter.dart';

class ResultsReviewScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final String imageId;

  const ResultsReviewScreen({
    super.key,
    required this.sessionId,
    required this.imageId,
  });

  @override
  ConsumerState<ResultsReviewScreen> createState() =>
      _ResultsReviewScreenState();
}

class _ResultsReviewScreenState extends ConsumerState<ResultsReviewScreen> {
  bool _showOverlays = true;
  late ReviewStatus _currentStatus;
  late TextEditingController _notesController;
  String? _correctedClass;

  final List<String> _correctionOptions = [
    'Aspergillus niger',
    'Aspergillus fumigatus',
    'Candida albicans',
    'Trichophyton rubrum',
    'Penicillium chrysogenum',
    'Microsporum canis',
    'Staining Artifact / Debris',
    'Unidentified Fungal Element',
  ];

  @override
  void initState() {
    super.initState();
    final run = _resolveRun();
    _currentStatus = run?.reviewStatus ?? ReviewStatus.pending;
    _notesController = TextEditingController(text: run?.reviewerNotes ?? '');
    _correctedClass = run?.correctedClass;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  AnalysisRun? _resolveRun() {
    final sessions = ref.read(sessionRepositoryProvider);
    final session = sessions.firstWhere((s) => s.id == widget.sessionId);
    final image = session.images.firstWhere((img) => img.id == widget.imageId);
    return image.analysisRun;
  }

  void _saveReview() {
    ref
        .read(sessionRepositoryProvider.notifier)
        .updateReviewStatus(
          sessionId: widget.sessionId,
          imageId: widget.imageId,
          status: _currentStatus,
          reviewerNotes: _notesController.text.trim(),
          correctedClass: _correctedClass,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Scientific review recorded as ${_currentStatus.displayName}.',
        ),
        backgroundColor: AppColors.passGreen,
      ),
    );

    context.pop();
  }

  void _showCorrectionDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Correct Classification'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _correctionOptions.length,
              itemBuilder: (context, index) {
                final option = _correctionOptions[index];
                return ListTile(
                  title: Text(option),
                  onTap: () {
                    setState(() {
                      _correctedClass = option;
                      _currentStatus = ReviewStatus.corrected;
                    });
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCEL'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(sessionRepositoryProvider);
    final session = sessions.firstWhere((s) => s.id == widget.sessionId);
    final image = session.images.firstWhere((img) => img.id == widget.imageId);
    final run = image.analysisRun;

    if (run == null) {
      return Scaffold(
        appBar: const ScientificAppBar(title: 'Results Viewer'),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No analysis run recorded for this field.'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('RETURN TO FIELD REVIEW'),
              ),
            ],
          ),
        ),
      );
    }

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
        title: 'Scientific Review',
        subtitle: '${session.specimenCode} • Field #${image.fieldIndex}',
        actions: [
          IconButton(
            tooltip: 'Toggle ROI Overlays',
            icon: Icon(
              _showOverlays ? Icons.layers : Icons.layers_clear,
              color: _showOverlays ? AppColors.signal : textSecondary,
              size: 20,
            ),
            onPressed: () => setState(() => _showOverlays = !_showOverlays),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          32 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          // Microscopic Field Viewport with Bounding Box Overlays
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 6.0,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(image.assetPath, fit: BoxFit.contain),
                          if (_showOverlays && run.annotations.isNotEmpty)
                            Positioned.fill(
                              child: CustomPaint(
                                painter: AnnotationOverlayPainter(
                                  annotations: run.annotations,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Row(
                      children: [
                        const StatusBadge(
                          label: 'AI PREDICTION (UNVERIFIED)',
                          type: BadgeType.modelPrediction,
                          icon: Icons.psychology,
                          isCompact: true,
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${run.processingMs} ms',
                            style: AppTypography.technicalMono(
                              Colors.white70,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Primary Finding Card
          ScientificCard(
            padding: const EdgeInsets.all(16),
            borderColor: _currentStatus == ReviewStatus.confirmed
                ? AppColors.passGreen.withOpacity(0.6)
                : (_currentStatus == ReviewStatus.corrected
                      ? AppColors.signal.withOpacity(0.6)
                      : null),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CLASSIFICATION HYPOTHESIS',
                      style: AppTypography.label(textSecondary),
                    ),
                    Text(
                      'CONFIDENCE: ${Formatters.formatPercentage(run.topPrediction.confidence)}',
                      style: AppTypography.technicalMono(
                        AppColors.signal,
                        fontSize: 12,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _correctedClass ?? run.topPrediction.className,
                  style: AppTypography.headline(textPrimary),
                ),
                if (_correctedClass != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const StatusBadge(
                        label: 'CORRECTED BY USER',
                        type: BadgeType.humanObservation,
                        isCompact: true,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Original: ${run.topPrediction.className}',
                        style: AppTypography.caption(textSecondary),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    run.topPrediction.scientificName,
                    style: AppTypography.caption(AppColors.signal)
                        .copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  run.topPrediction.morphologicalFeatures,
                  style: AppTypography.body(textSecondary)
                      .copyWith(fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Secondary Probabilistic Candidates
          if (run.allPredictions.length > 1) ...[
            ScientificCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SECONDARY CANDIDATES (POSTERIOR DISTRIBUTION)',
                    style: AppTypography.label(textSecondary),
                  ),
                  const SizedBox(height: 12),
                  for (final cand in run.allPredictions.skip(1)) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cand.className,
                                style: AppTypography.body(textPrimary)
                                    .copyWith(fontSize: 13),
                              ),
                              Text(
                                Formatters.formatPercentage(cand.confidence),
                                style: AppTypography.technicalMono(
                                  textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: cand.confidence,
                            backgroundColor: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                            color: AppColors.signal.withOpacity(0.7),
                            minHeight: 3,
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Human Verification Actions (4 Scientific States)
          Text(
            'LABORATORY VERIFICATION DECISION',
            style: AppTypography.label(textSecondary),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _decisionButton(
                  label: 'CONFIRM',
                  status: ReviewStatus.confirmed,
                  icon: Icons.check_circle_outline,
                  color: AppColors.passGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _decisionButton(
                  label: 'CORRECT',
                  status: ReviewStatus.corrected,
                  icon: Icons.edit_note,
                  color: AppColors.signal,
                  onCustomTap: _showCorrectionDialog,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _decisionButton(
                  label: 'REJECT',
                  status: ReviewStatus.rejected,
                  icon: Icons.cancel_outlined,
                  color: AppColors.dangerRose,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _decisionButton(
                  label: 'EXPERT REVIEW',
                  status: ReviewStatus.needsFurtherReview,
                  icon: Icons.help_outline,
                  color: AppColors.warningAmber,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Microscopist Notes & Justification
          ScientificCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REVIEWER SIGN-OFF NOTES',
                  style: AppTypography.label(textSecondary),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Diagnostic phialide branching confirmed under 40x objective.',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Commit Review Action
          FilledButton(
            onPressed: _saveReview,
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
                const Icon(Icons.save_outlined, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'RECORD VERIFICATION DECISION',
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _decisionButton({
    required String label,
    required ReviewStatus status,
    required IconData icon,
    required Color color,
    VoidCallback? onCustomTap,
  }) {
    final isSelected = _currentStatus == status;
    return InkWell(
      onTap: onCustomTap ?? () => setState(() => _currentStatus = status),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.35),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: AppTypography.technicalMono(
                    color,
                    fontSize: 11,
                    weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
