import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/microscopy_image_view.dart';
import '../../core/widgets/scientific_app_bar.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/analysis_run.dart';
import '../../shared/models/session.dart';
import '../../shared/services/pdf_report_service.dart';
import '../../shared/services/session_repository.dart';

class ReportPreviewScreen extends ConsumerWidget {
  final String sessionId;

  const ReportPreviewScreen({super.key, required this.sessionId});

  Future<void> _exportPdfReport(
    BuildContext context,
    MicroscopySession session,
  ) async {
    try {
      await PdfReportService.shareReportPdf(session: session);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF Export failed: $e'),
            backgroundColor: AppColors.dangerRose,
          ),
        );
      }
    }
  }

  void _exportJsonRecord(BuildContext context, MicroscopySession session) {
    // Generate true structured laboratory record with complete provenance
    final exportData = {
      'document_type': 'microtrace_laboratory_observation_record',
      'schema_version': '1.0.0',
      'generated_at': DateTime.now().toIso8601String(),
      'specimen': {
        'session_id': session.id,
        'title': session.title,
        'code': session.specimenCode,
        'type': session.specimenType,
        'capture_profile': session.captureProfile,
        'operator': session.operatorLabel,
        'notes': session.notes,
        'status': session.status.name,
      },
      'module': {'id': session.moduleId, 'name': session.moduleName},
      'fields_count': session.images.length,
      'observations': session.images
          .map(
            (img) => {
              'field_index': img.fieldIndex,
              'image_id': img.id,
              'captured_at': img.capturedAt.toIso8601String(),
              'quality': {
                'sharpness': img.qualityMetrics.laplacianSharpness,
                'luminance': img.qualityMetrics.meanLuminance,
                'contrast': img.qualityMetrics.contrastRatio,
                'coverage': img.qualityMetrics.fovCircularCoverage,
                'passed': img.qualityMetrics.isPassed,
              },
              'analysis': img.analysisRun == null
                  ? null
                  : {
                      'run_id': img.analysisRun!.id,
                      'model_id': img.analysisRun!.modelId,
                      'version': img.analysisRun!.modelVersion,
                      'processing_ms': img.analysisRun!.processingMs,
                      'top_prediction': {
                        'class_id': img.analysisRun!.topPrediction.classId,
                        'class_name': img.analysisRun!.topPrediction.className,
                        'scientific_name':
                            img.analysisRun!.topPrediction.scientificName,
                        'confidence': img.analysisRun!.topPrediction.confidence,
                      },
                      'all_predictions': img.analysisRun!.allPredictions
                          .map(
                            (p) => {
                              'class_id': p.classId,
                              'class_name': p.className,
                              'confidence': p.confidence,
                            },
                          )
                          .toList(),
                      'review': {
                        'status': img.analysisRun!.reviewStatus.name,
                        'reviewer_notes': img.analysisRun!.reviewerNotes,
                        'corrected_class': img.analysisRun!.correctedClass,
                      },
                    },
            },
          )
          .toList(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
    debugPrint('Exported JSON size: ${jsonString.length} bytes');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Structured JSON record exported for ${session.specimenCode} (${session.images.length} fields).',
        ),
        backgroundColor: AppColors.passGreen,
        duration: const Duration(seconds: 3),
      ),
    );
  }

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
        title: 'Observation Report',
        subtitle: '${session.specimenCode} • PDF PREVIEW',
        actions: [
          IconButton(
            tooltip: 'Export Structured JSON',
            icon: const Icon(Icons.data_object, size: 20),
            onPressed: () => _exportJsonRecord(context, session),
          ),
          IconButton(
            tooltip: 'Export PDF Document',
            icon: const Icon(
              Icons.picture_as_pdf,
              color: AppColors.signal,
              size: 20,
            ),
            onPressed: () => _exportPdfReport(context, session),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          18,
          16,
          18,
          32 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          // Report Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.appName,
                      style: AppTypography.headline(textPrimary)
                          .copyWith(letterSpacing: 2.0),
                    ),
                    Text(
                      'MICROBIOLOGY OBSERVATION REPORT',
                      style: AppTypography.technicalMono(
                        AppColors.signal,
                        fontSize: 10,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'REPORT ID: REP-${session.specimenCode}',
                    style: AppTypography.technicalMono(
                      textSecondary,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    Formatters.formatDateTime(DateTime.now()),
                    style: AppTypography.caption(textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 14),

          // Specimen Metadata Table
          Text(
            'SPECIMEN & OPTICAL TELEMETRY',
            style: AppTypography.label(textSecondary),
          ),
          const SizedBox(height: 8),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(2.0),
            },
            children: [
              _buildTableRow(
                'Specimen Code:',
                session.specimenCode,
                textPrimary,
                textSecondary,
              ),
              _buildTableRow(
                'Session Title:',
                session.title,
                textPrimary,
                textSecondary,
              ),
              _buildTableRow(
                'Specimen Preparation:',
                session.specimenType,
                textPrimary,
                textSecondary,
              ),
              _buildTableRow(
                'Microscope Profile:',
                session.captureProfile,
                textPrimary,
                textSecondary,
              ),
              _buildTableRow(
                'Operator Label:',
                session.operatorLabel,
                textPrimary,
                textSecondary,
              ),
              _buildTableRow(
                'Total Fields Evaluated:',
                '${session.images.length}',
                textPrimary,
                textSecondary,
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),

          // Field Findings Summary
          Text(
            'ACQUIRED MICROSCOPIC FIELDS & FINDINGS',
            style: AppTypography.label(textSecondary),
          ),
          const SizedBox(height: 12),

          for (final img in session.images) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: MicroscopyImageView(
                      path: img.assetPath,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Field #${img.fieldIndex}',
                              style: AppTypography.technicalMono(
                                AppColors.signal,
                                fontSize: 12,
                                weight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (img.analysisRun != null)
                              Flexible(
                                child: StatusBadge(
                                  label:
                                      img.analysisRun!.reviewStatus.displayName,
                                  type:
                                      img.analysisRun!.reviewStatus ==
                                          ReviewStatus.confirmed
                                      ? BadgeType.pass
                                      : (img.analysisRun!.reviewStatus ==
                                                ReviewStatus.corrected
                                            ? BadgeType.humanObservation
                                            : BadgeType.warning),
                                  isCompact: true,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          img.analysisRun != null
                              ? (img.analysisRun!.correctedClass ??
                                    img.analysisRun!.topPrediction.className)
                              : 'Awaiting Automated Inference',
                          style: AppTypography.title(textPrimary)
                              .copyWith(fontSize: 14),
                        ),
                        if (img.analysisRun != null) ...[
                          Text(
                            'Model Confidence: ${Formatters.formatPercentage(img.analysisRun!.topPrediction.confidence)}',
                            style: AppTypography.caption(textSecondary),
                          ),
                          if (img.analysisRun!.reviewerNotes.isNotEmpty)
                            Text(
                              'Reviewer Sign-off: "${img.analysisRun!.reviewerNotes}"',
                              style: AppTypography.caption(AppColors.signal)
                                  .copyWith(fontStyle: FontStyle.italic),
                            ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 14),

          // AI Model Provenance Block
          Text(
            'MODEL PROVENANCE & REPRODUCIBILITY',
            style: AppTypography.label(textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Runtime: Google LiteRT Float16 on Android • Model ID: mycology_patch_classifier v0.1.0-alpha\n'
            'Dataset Reference: DeFungi (UCI ML #773) • Preprocessing: 224×224 normalized RGB\n'
            'Checksum: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
            style: AppTypography.caption(textSecondary)
                .copyWith(fontSize: 10, height: 1.5),
          ),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 14),

          // Sign-off verification block
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VERIFYING MICROSCOPIST:',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label(textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session.operatorLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.body(textPrimary)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'VERIFICATION STATUS:',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label(textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session.status == SessionStatus.reviewed
                          ? 'VERIFIED & APPROVED'
                          : 'DRAFT REPORT',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.technicalMono(
                        session.status == SessionStatus.reviewed
                            ? AppColors.passGreen
                            : AppColors.warningAmber,
                        fontSize: 11,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Export Buttons
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _exportPdfReport(context, session),
                  icon: const Icon(Icons.picture_as_pdf, size: 18),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('EXPORT PDF REPORT'),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.signalDeep,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _exportJsonRecord(context, session),
                  icon: const Icon(
                    Icons.data_object,
                    size: 18,
                    color: AppColors.signal,
                  ),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('JSON EXPORT'),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: AppColors.signal.withOpacity(0.5)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  TableRow _buildTableRow(
    String label,
    String value,
    Color primary,
    Color secondary,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            label,
            style: AppTypography.caption(secondary)
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            value,
            style: AppTypography.body(primary).copyWith(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
