import 'analysis_run.dart';
import 'quality_metrics.dart';

class MicroscopyImage {
  final String id;
  final String sessionId;
  final int fieldIndex;
  final String assetPath;
  final String? derivedPath;
  final DateTime capturedAt;
  final int width;
  final int height;
  final String captureProfile;
  final bool isUsable;
  final bool recaptureNeeded;
  final String notes;
  final QualityMetrics qualityMetrics;
  final AnalysisRun? analysisRun;

  const MicroscopyImage({
    required this.id,
    required this.sessionId,
    required this.fieldIndex,
    required this.assetPath,
    this.derivedPath,
    required this.capturedAt,
    this.width = 1920,
    this.height = 1080,
    this.captureProfile = '40x Achromat • Brightfield',
    this.isUsable = true,
    this.recaptureNeeded = false,
    this.notes = '',
    required this.qualityMetrics,
    this.analysisRun,
  });

  MicroscopyImage copyWith({
    String? id,
    String? sessionId,
    int? fieldIndex,
    String? assetPath,
    String? derivedPath,
    DateTime? capturedAt,
    int? width,
    int? height,
    String? captureProfile,
    bool? isUsable,
    bool? recaptureNeeded,
    String? notes,
    QualityMetrics? qualityMetrics,
    AnalysisRun? analysisRun,
  }) {
    return MicroscopyImage(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      fieldIndex: fieldIndex ?? this.fieldIndex,
      assetPath: assetPath ?? this.assetPath,
      derivedPath: derivedPath ?? this.derivedPath,
      capturedAt: capturedAt ?? this.capturedAt,
      width: width ?? this.width,
      height: height ?? this.height,
      captureProfile: captureProfile ?? this.captureProfile,
      isUsable: isUsable ?? this.isUsable,
      recaptureNeeded: recaptureNeeded ?? this.recaptureNeeded,
      notes: notes ?? this.notes,
      qualityMetrics: qualityMetrics ?? this.qualityMetrics,
      analysisRun: analysisRun ?? this.analysisRun,
    );
  }
}
