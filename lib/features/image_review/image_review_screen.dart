import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/widgets/quality_gauge.dart';
import '../../core/widgets/scientific_app_bar.dart';
import '../../core/widgets/scientific_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/analysis_run.dart';
import '../../shared/models/microscopy_image.dart';
import '../../shared/services/session_repository.dart';

class ImageReviewScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final String imageId;

  const ImageReviewScreen({
    super.key,
    required this.sessionId,
    required this.imageId,
  });

  @override
  ConsumerState<ImageReviewScreen> createState() => _ImageReviewScreenState();
}

class _ImageReviewScreenState extends ConsumerState<ImageReviewScreen> {
  late TextEditingController _notesController;
  late bool _isUsable;
  late bool _recaptureNeeded;

  @override
  void initState() {
    super.initState();
    final image = _resolveImage();
    _notesController = TextEditingController(text: image?.notes ?? '');
    _isUsable = image?.isUsable ?? true;
    _recaptureNeeded = image?.recaptureNeeded ?? false;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  MicroscopyImage? _resolveImage() {
    final sessions = ref.read(sessionRepositoryProvider);
    final session = sessions.firstWhere((s) => s.id == widget.sessionId);
    return session.images.firstWhere((img) => img.id == widget.imageId);
  }

  void _saveChanges() {
    final image = _resolveImage();
    if (image == null) return;

    final updated = image.copyWith(
      isUsable: _isUsable,
      recaptureNeeded: _recaptureNeeded,
      notes: _notesController.text.trim(),
    );

    ref
        .read(sessionRepositoryProvider.notifier)
        .updateImage(widget.sessionId, updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Field metadata updated successfully.'),
        backgroundColor: AppColors.passGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Field'),
        content: const Text(
          'Are you sure you want to remove this microscopic field from the session?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(sessionRepositoryProvider.notifier)
                  .removeImage(widget.sessionId, widget.imageId);
              context.pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.dangerRose),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(sessionRepositoryProvider);
    final session = sessions.firstWhere(
      (s) => s.id == widget.sessionId,
      orElse: () => throw Exception('Session not found'),
    );
    final image = session.images.firstWhere(
      (img) => img.id == widget.imageId,
      orElse: () => throw Exception('Image not found'),
    );

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final metrics = image.qualityMetrics;

    return Scaffold(
      appBar: ScientificAppBar(
        title: 'Field #${image.fieldIndex} Review',
        subtitle: '${session.specimenCode} • ${image.captureProfile}',
        actions: [
          IconButton(
            tooltip: 'Delete Field',
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.dangerRose,
              size: 20,
            ),
            onPressed: _confirmDelete,
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
          // High-Res Image Inspection Area with Interactive Viewer
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
                      child: Image.asset(image.assetPath, fit: BoxFit.contain),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'PINCH / PAN TO ZOOM (UP TO 6X)',
                        style: AppTypography.technicalMono(
                          Colors.white70,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: StatusBadge(
                      label: metrics.isPassed
                          ? 'QUALITY GATE PASSED'
                          : 'QUALITY WARNING',
                      type: metrics.isPassed
                          ? BadgeType.pass
                          : BadgeType.warning,
                      isCompact: true,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quality Assessment Card
          ScientificCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'OPTICAL QUALITY METRICS',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.label(textSecondary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'HEURISTIC ENGINE V1.2',
                      style: AppTypography.technicalMono(
                        textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                QualityGauge(
                  label: 'Laplacian Sharpness (Focus)',
                  score: metrics.laplacianSharpness / 100.0,
                  threshold: 0.70,
                  valueText:
                      '${metrics.laplacianSharpness.toStringAsFixed(1)} / 100',
                  isPass: metrics.laplacianSharpness >= 70.0,
                ),
                const SizedBox(height: 12),
                QualityGauge(
                  label: 'Mean Field Luminance (Exposure)',
                  score: metrics.meanLuminance,
                  threshold: 0.50,
                  valueText:
                      '${(metrics.meanLuminance * 100).toStringAsFixed(0)}% Nominal',
                  isPass:
                      metrics.meanLuminance >= 0.45 &&
                      metrics.meanLuminance <= 0.85,
                ),
                const SizedBox(height: 12),
                QualityGauge(
                  label: 'Circular Eyepiece Aperture Alignment',
                  score: metrics.fovCircularCoverage,
                  threshold: 0.80,
                  valueText:
                      '${(metrics.fovCircularCoverage * 100).toStringAsFixed(0)}% Centered',
                  isPass: metrics.fovCircularCoverage >= 0.80,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Usability Flags & Notes Card
          ScientificCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FIELD STATUS & LAB OBSERVATIONS',
                  style: AppTypography.label(textSecondary),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isUsable = true;
                            _recaptureNeeded = false;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _isUsable
                                ? AppColors.passGreen.withOpacity(0.18)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isUsable
                                  ? AppColors.passGreen
                                  : (isDark
                                        ? AppColors.darkBorder
                                        : AppColors.lightBorder),
                              width: _isUsable ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isUsable
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                                size: 16,
                                color: _isUsable
                                    ? AppColors.passGreen
                                    : textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'USABLE FIELD',
                                    style: AppTypography.technicalMono(
                                      _isUsable
                                          ? AppColors.passGreen
                                          : textSecondary,
                                      fontSize: 11,
                                      weight: _isUsable
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _recaptureNeeded = true;
                            _isUsable = false;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _recaptureNeeded
                                ? AppColors.warningAmber.withOpacity(0.18)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _recaptureNeeded
                                  ? AppColors.warningAmber
                                  : (isDark
                                        ? AppColors.darkBorder
                                        : AppColors.lightBorder),
                              width: _recaptureNeeded ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.replay,
                                size: 16,
                                color: _recaptureNeeded
                                    ? AppColors.warningAmber
                                    : textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'FLAG RECAPTURE',
                                    style: AppTypography.technicalMono(
                                      _recaptureNeeded
                                          ? AppColors.warningAmber
                                          : textSecondary,
                                      fontSize: 11,
                                      weight: _recaptureNeeded
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Microscopist Notes',
                    hintText: 'e.g. Clean field, distinct conidial phialides visible.',
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _saveChanges,
                    icon: const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.signal,
                    ),
                    label: Text(
                      'SAVE FIELD OBSERVATIONS',
                      style: AppTypography.technicalMono(
                        AppColors.signal,
                        fontSize: 11,
                        weight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      side: BorderSide(
                        color: AppColors.signal.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Primary Action: Run Analysis or View Results
          if (image.analysisRun != null)
            FilledButton(
              onPressed: () {
                context.push(
                  '/session/${session.id}/image/${image.id}/results',
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.modelPredictionPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.analytics_outlined, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'VIEW ANALYSIS & VERIFY (${image.analysisRun!.reviewStatus.displayName.toUpperCase()})',
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
            )
          else
            FilledButton(
              onPressed: () {
                context.push(
                  '/session/${session.id}/image/${image.id}/analysis',
                );
              },
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
                  const Icon(Icons.psychology_outlined, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'PROCEED TO ON-DEVICE ANALYSIS',
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

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
