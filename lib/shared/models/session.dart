import 'microscopy_image.dart';

enum SessionStatus {
  inProgress,
  completed,
  reviewed,
}

extension SessionStatusExtension on SessionStatus {
  String get displayName {
    switch (this) {
      case SessionStatus.inProgress:
        return 'In Progress';
      case SessionStatus.completed:
        return 'Completed';
      case SessionStatus.reviewed:
        return 'Reviewed';
    }
  }
}

class MicroscopySession {
  final String id;
  final String title;
  final String specimenCode;
  final String specimenType;
  final String moduleId;
  final String moduleName;
  final String captureProfile;
  final DateTime createdAt;
  final String operatorLabel;
  final String notes;
  final SessionStatus status;
  final List<MicroscopyImage> images;

  const MicroscopySession({
    required this.id,
    required this.title,
    required this.specimenCode,
    required this.specimenType,
    required this.moduleId,
    required this.moduleName,
    this.captureProfile = '40x Achromat • Brightfield',
    required this.createdAt,
    this.operatorLabel = 'Lab Tech (Primary)',
    this.notes = '',
    this.status = SessionStatus.inProgress,
    this.images = const [],
  });

  MicroscopySession copyWith({
    String? id,
    String? title,
    String? specimenCode,
    String? specimenType,
    String? moduleId,
    String? moduleName,
    String? captureProfile,
    DateTime? createdAt,
    String? operatorLabel,
    String? notes,
    SessionStatus? status,
    List<MicroscopyImage>? images,
  }) {
    return MicroscopySession(
      id: id ?? this.id,
      title: title ?? this.title,
      specimenCode: specimenCode ?? this.specimenCode,
      specimenType: specimenType ?? this.specimenType,
      moduleId: moduleId ?? this.moduleId,
      moduleName: moduleName ?? this.moduleName,
      captureProfile: captureProfile ?? this.captureProfile,
      createdAt: createdAt ?? this.createdAt,
      operatorLabel: operatorLabel ?? this.operatorLabel,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      images: images ?? this.images,
    );
  }
}
