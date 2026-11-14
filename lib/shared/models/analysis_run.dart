import 'annotation.dart';

enum ReviewStatus {
  pending,
  confirmed,
  corrected,
  rejected,
  needsFurtherReview,
}

extension ReviewStatusExtension on ReviewStatus {
  String get displayName {
    switch (this) {
      case ReviewStatus.pending:
        return 'Pending Review';
      case ReviewStatus.confirmed:
        return 'Confirmed';
      case ReviewStatus.corrected:
        return 'Corrected';
      case ReviewStatus.rejected:
        return 'Rejected';
      case ReviewStatus.needsFurtherReview:
        return 'Needs Expert Review';
    }
  }
}

class PredictionResult {
  final String classId;
  final String className;
  final String scientificName;
  final double confidence; // 0.0 to 1.0
  final String morphologicalFeatures;

  const PredictionResult({
    required this.classId,
    required this.className,
    required this.scientificName,
    required this.confidence,
    required this.morphologicalFeatures,
  });

  PredictionResult copyWith({
    String? classId,
    String? className,
    String? scientificName,
    double? confidence,
    String? morphologicalFeatures,
  }) {
    return PredictionResult(
      classId: classId ?? this.classId,
      className: className ?? this.className,
      scientificName: scientificName ?? this.scientificName,
      confidence: confidence ?? this.confidence,
      morphologicalFeatures:
          morphologicalFeatures ?? this.morphologicalFeatures,
    );
  }
}

class AnalysisRun {
  final String id;
  final String imageId;
  final String modelId;
  final String modelVersion;
  final String taskType; // image_classification, object_detection
  final DateTime startedAt;
  final DateTime completedAt;
  final int processingMs;
  final PredictionResult topPrediction;
  final List<PredictionResult> allPredictions;
  final List<Annotation> annotations;
  final ReviewStatus reviewStatus;
  final String reviewerNotes;
  final String? correctedClass;
  final bool isSimulated;

  const AnalysisRun({
    required this.id,
    required this.imageId,
    required this.modelId,
    required this.modelVersion,
    required this.taskType,
    required this.startedAt,
    required this.completedAt,
    required this.processingMs,
    required this.topPrediction,
    this.allPredictions = const [],
    this.annotations = const [],
    this.reviewStatus = ReviewStatus.pending,
    this.reviewerNotes = '',
    this.correctedClass,
    this.isSimulated = true,
  });

  AnalysisRun copyWith({
    String? id,
    String? imageId,
    String? modelId,
    String? modelVersion,
    String? taskType,
    DateTime? startedAt,
    DateTime? completedAt,
    int? processingMs,
    PredictionResult? topPrediction,
    List<PredictionResult>? allPredictions,
    List<Annotation>? annotations,
    ReviewStatus? reviewStatus,
    String? reviewerNotes,
    String? correctedClass,
    bool? isSimulated,
  }) {
    return AnalysisRun(
      id: id ?? this.id,
      imageId: imageId ?? this.imageId,
      modelId: modelId ?? this.modelId,
      modelVersion: modelVersion ?? this.modelVersion,
      taskType: taskType ?? this.taskType,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      processingMs: processingMs ?? this.processingMs,
      topPrediction: topPrediction ?? this.topPrediction,
      allPredictions: allPredictions ?? this.allPredictions,
      annotations: annotations ?? this.annotations,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      reviewerNotes: reviewerNotes ?? this.reviewerNotes,
      correctedClass: correctedClass ?? this.correctedClass,
      isSimulated: isSimulated ?? this.isSimulated,
    );
  }
}
