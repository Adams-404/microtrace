class RectNormalized {
  final double x; // 0.0 to 1.0 (left)
  final double y; // 0.0 to 1.0 (top)
  final double width; // 0.0 to 1.0
  final double height; // 0.0 to 1.0

  const RectNormalized({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
      };

  factory RectNormalized.fromJson(Map<String, dynamic> json) => RectNormalized(
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        width: (json['width'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
      );
}

class Annotation {
  final String id;
  final String classId;
  final String label;
  final RectNormalized boxNormalized;
  final double confidence;
  final bool isModelGenerated;
  final bool isUserModified;

  const Annotation({
    required this.id,
    required this.classId,
    required this.label,
    required this.boxNormalized,
    required this.confidence,
    this.isModelGenerated = true,
    this.isUserModified = false,
  });

  Annotation copyWith({
    String? id,
    String? classId,
    String? label,
    RectNormalized? boxNormalized,
    double? confidence,
    bool? isModelGenerated,
    bool? isUserModified,
  }) {
    return Annotation(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      label: label ?? this.label,
      boxNormalized: boxNormalized ?? this.boxNormalized,
      confidence: confidence ?? this.confidence,
      isModelGenerated: isModelGenerated ?? this.isModelGenerated,
      isUserModified: isUserModified ?? this.isUserModified,
    );
  }
}
