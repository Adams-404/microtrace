class QualityMetrics {
  final double laplacianSharpness; // 0 to 100
  final double meanLuminance; // 0.0 to 1.0
  final double contrastRatio; // 0.0 to 1.0
  final double fovCircularCoverage; // 0.0 to 1.0
  final bool isPassed;
  final List<String> warnings;

  const QualityMetrics({
    required this.laplacianSharpness,
    required this.meanLuminance,
    required this.contrastRatio,
    required this.fovCircularCoverage,
    required this.isPassed,
    this.warnings = const [],
  });

  QualityMetrics copyWith({
    double? laplacianSharpness,
    double? meanLuminance,
    double? contrastRatio,
    double? fovCircularCoverage,
    bool? isPassed,
    List<String>? warnings,
  }) {
    return QualityMetrics(
      laplacianSharpness: laplacianSharpness ?? this.laplacianSharpness,
      meanLuminance: meanLuminance ?? this.meanLuminance,
      contrastRatio: contrastRatio ?? this.contrastRatio,
      fovCircularCoverage: fovCircularCoverage ?? this.fovCircularCoverage,
      isPassed: isPassed ?? this.isPassed,
      warnings: warnings ?? this.warnings,
    );
  }

  static QualityMetrics nominal({
    double sharpness = 86.4,
    double luminance = 0.65,
    double contrast = 0.78,
    double coverage = 0.94,
  }) {
    return QualityMetrics(
      laplacianSharpness: sharpness,
      meanLuminance: luminance,
      contrastRatio: contrast,
      fovCircularCoverage: coverage,
      isPassed: sharpness >= 65.0 && luminance >= 0.4 && luminance <= 0.88,
      warnings: [],
    );
  }
}
