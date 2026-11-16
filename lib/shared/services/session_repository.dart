import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../database/database_provider.dart';
import '../models/analysis_run.dart';
import '../models/microscopy_image.dart';
import '../models/session.dart';

final sessionRepositoryProvider =
    NotifierProvider<SessionRepositoryNotifier, List<MicroscopySession>>(
      SessionRepositoryNotifier.new,
    );

class SessionRepositoryNotifier extends Notifier<List<MicroscopySession>> {
  final _uuid = const Uuid();

  AppDatabase get _db => ref.read(appDatabaseProvider);

  @override
  List<MicroscopySession> build() {
    _loadFromDb();
    return const [];
  }

  Future<void> _loadFromDb() async {
    try {
      final dbSessions = await _db.getAllSessions();
      if (dbSessions.isNotEmpty) {
        state = dbSessions;
      }
    } catch (_) {
      // Graceful fallback to in-memory state
    }
  }

  void createSession({
    required String title,
    required String specimenCode,
    required String specimenType,
    required String moduleId,
    required String moduleName,
    required String captureProfile,
    required String operatorLabel,
    required String notes,
  }) {
    final newSession = MicroscopySession(
      id: _uuid.v4(),
      title: title,
      specimenCode: specimenCode,
      specimenType: specimenType,
      moduleId: moduleId,
      moduleName: moduleName,
      captureProfile: captureProfile,
      createdAt: DateTime.now(),
      operatorLabel: operatorLabel,
      notes: notes,
      status: SessionStatus.inProgress,
      images: [],
    );

    state = [newSession, ...state];
    _db.saveSession(newSession).catchError((_) {});
  }

  void updateSession(MicroscopySession updated) {
    state = [
      for (final s in state)
        if (s.id == updated.id) updated else s,
    ];
    _db.saveSession(updated).catchError((_) {});
  }

  void deleteSession(String sessionId) {
    state = state.where((s) => s.id != sessionId).toList();
    _db.deleteSessionCascade(sessionId).catchError((_) {});
  }

  void addImageToSession(String sessionId, MicroscopyImage image) {
    state = [
      for (final s in state)
        if (s.id == sessionId) s.copyWith(images: [...s.images, image]) else s,
    ];
    _db.saveImage(image).catchError((_) {});
  }

  void updateImage(String sessionId, MicroscopyImage updatedImage) {
    state = [
      for (final s in state)
        if (s.id == sessionId)
          s.copyWith(
            images: [
              for (final img in s.images)
                if (img.id == updatedImage.id) updatedImage else img,
            ],
          )
        else
          s,
    ];
    _db.saveImage(updatedImage).catchError((_) {});
  }

  void removeImage(String sessionId, String imageId) {
    state = [
      for (final s in state)
        if (s.id == sessionId)
          s.copyWith(
            images: s.images.where((img) => img.id != imageId).toList(),
          )
        else
          s,
    ];
    _db.deleteImageCascade(imageId).catchError((_) {});
  }

  void updateAnalysisResult({
    required String sessionId,
    required String imageId,
    required AnalysisRun run,
  }) {
    state = [
      for (final s in state)
        if (s.id == sessionId)
          s.copyWith(
            images: [
              for (final img in s.images)
                if (img.id == imageId) img.copyWith(analysisRun: run) else img,
            ],
          )
        else
          s,
    ];
    _db.saveAnalysisRun(run).catchError((_) {});
  }

  void updateReviewStatus({
    required String sessionId,
    required String imageId,
    required ReviewStatus status,
    required String reviewerNotes,
    String? correctedClass,
  }) {
    AnalysisRun? updatedRun;
    state = [
      for (final s in state)
        if (s.id == sessionId)
          s.copyWith(
            images: [
              for (final img in s.images)
                if (img.id == imageId && img.analysisRun != null)
                  () {
                    final newRun = img.analysisRun!.copyWith(
                      reviewStatus: status,
                      reviewerNotes: reviewerNotes,
                      correctedClass: correctedClass,
                    );
                    updatedRun = newRun;
                    return img.copyWith(analysisRun: newRun);
                  }()
                else
                  img,
            ],
          )
        else
          s,
    ];
    if (updatedRun != null) {
      _db.saveAnalysisRun(updatedRun!).catchError((_) {});
    }
  }

  /// Exports full structured database records as JSON for backup workflows
  Future<Map<String, dynamic>> exportDatabaseBackup() async {
    return _db.exportToJson();
  }

  /// Purges all database sessions
  Future<void> purgeAllSessions() async {
    state = [];
    await _db.purgeDatabase().catchError((_) {});
  }
}
