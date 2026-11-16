import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/analysis_run.dart';
import '../models/annotation.dart';
import '../models/microscopy_image.dart';
import '../models/model_installation.dart';
import '../models/quality_metrics.dart';
import '../models/session.dart';

part 'app_database.g.dart';

// --- TABLE DEFINITIONS ---

@TableIndex(name: 'session_created_at_idx', columns: {#createdAt})
@TableIndex(name: 'session_specimen_code_idx', columns: {#specimenCode})
class SessionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get specimenCode => text()();
  TextColumn get specimenType => text()();
  TextColumn get moduleId => text()();
  TextColumn get moduleName => text()();
  TextColumn get captureProfile =>
      text().withDefault(const Constant('40x Achromat • Brightfield'))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get operatorLabel =>
      text().withDefault(const Constant('Lab Tech (Primary)'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('inProgress'))();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(name: 'image_session_id_idx', columns: {#sessionId})
class ImagesTable extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId =>
      text().references(SessionsTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get fieldIndex => integer()();
  TextColumn get assetPath => text()();
  TextColumn get derivedPath => text().nullable()();
  DateTimeColumn get capturedAt => dateTime()();
  IntColumn get width => integer().withDefault(const Constant(1920))();
  IntColumn get height => integer().withDefault(const Constant(1080))();
  TextColumn get captureProfile =>
      text().withDefault(const Constant('40x Achromat • Brightfield'))();
  BoolColumn get isUsable => boolean().withDefault(const Constant(true))();
  BoolColumn get recaptureNeeded =>
      boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().withDefault(const Constant(''))();

  // Embedded Quality Metrics for fast retrieval
  RealColumn get laplacianSharpness => real()();
  RealColumn get meanLuminance => real()();
  RealColumn get contrastRatio => real()();
  RealColumn get fovCircularCoverage => real()();
  BoolColumn get isQualityPassed => boolean()();
  TextColumn get qualityWarningsJson =>
      text().withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(name: 'analysis_run_image_id_idx', columns: {#imageId})
class AnalysisRunsTable extends Table {
  TextColumn get id => text()();
  TextColumn get imageId =>
      text().references(ImagesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get modelId => text()();
  TextColumn get modelVersion => text()();
  TextColumn get taskType => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime()();
  IntColumn get processingMs => integer()();
  TextColumn get topPredictionJson => text()();
  TextColumn get allPredictionsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get reviewStatus =>
      text().withDefault(const Constant('pending'))();
  TextColumn get reviewerNotes => text().withDefault(const Constant(''))();
  TextColumn get correctedClass => text().nullable()();
  BoolColumn get isSimulated => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(name: 'annotation_run_id_idx', columns: {#analysisRunId})
class AnnotationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get analysisRunId =>
      text().references(AnalysisRunsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get classId => text()();
  TextColumn get label => text()();
  RealColumn get boxX => real()();
  RealColumn get boxY => real()();
  RealColumn get boxWidth => real()();
  RealColumn get boxHeight => real()();
  RealColumn get confidence => real()();
  BoolColumn get isModelGenerated =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get isUserModified =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class ModelInstallationsTable extends Table {
  TextColumn get modelId => text()();
  TextColumn get name => text()();
  TextColumn get version => text()();
  TextColumn get moduleId => text()();
  TextColumn get runtime => text()();
  TextColumn get taskType => text()();
  IntColumn get sizeBytes => integer()();
  TextColumn get sha256Checksum => text()();
  BoolColumn get isInstalled => boolean().withDefault(const Constant(false))();
  DateTimeColumn get installedAt => dateTime()();
  TextColumn get accuracyReport => text()();
  TextColumn get inputDimensions => text()();

  @override
  Set<Column> get primaryKey => {modelId};
}

// --- DATABASE CLASS ---

@DriftDatabase(
  tables: [
    SessionsTable,
    ImagesTable,
    AnalysisRunsTable,
    AnnotationsTable,
    ModelInstallationsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'microtrace_db'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Future migration pathways
    },
  );

  // --- REPOSITORY & DAO OPERATIONS ---

  /// Retrieve all sessions with their corresponding images, analyses, and annotations
  Future<List<MicroscopySession>> getAllSessions() async {
    final sessionRows =
        await (select(sessionsTable)..orderBy([
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
            .get();

    if (sessionRows.isEmpty) return [];

    final imageRows = await select(imagesTable).get();
    final analysisRows = await select(analysisRunsTable).get();
    final annotationRows = await select(annotationsTable).get();

    // Map annotations by run ID
    final annotationsByRun = <String, List<Annotation>>{};
    for (final a in annotationRows) {
      final ann = Annotation(
        id: a.id,
        classId: a.classId,
        label: a.label,
        boxNormalized: RectNormalized(
          x: a.boxX,
          y: a.boxY,
          width: a.boxWidth,
          height: a.boxHeight,
        ),
        confidence: a.confidence,
        isModelGenerated: a.isModelGenerated,
        isUserModified: a.isUserModified,
      );
      annotationsByRun.putIfAbsent(a.analysisRunId, () => []).add(ann);
    }

    // Map analysis runs by image ID
    final analysisByImage = <String, AnalysisRun>{};
    for (final r in analysisRows) {
      final topPredMap =
          jsonDecode(r.topPredictionJson) as Map<String, dynamic>;
      final allPredsList = (jsonDecode(r.allPredictionsJson) as List<dynamic>)
          .map(
            (e) => PredictionResult(
              classId: e['classId'] as String,
              className: e['className'] as String,
              scientificName: e['scientificName'] as String,
              confidence: (e['confidence'] as num).toDouble(),
              morphologicalFeatures: e['morphologicalFeatures'] as String,
            ),
          )
          .toList();

      final status = ReviewStatus.values.firstWhere(
        (e) => e.name == r.reviewStatus,
        orElse: () => ReviewStatus.pending,
      );

      final run = AnalysisRun(
        id: r.id,
        imageId: r.imageId,
        modelId: r.modelId,
        modelVersion: r.modelVersion,
        taskType: r.taskType,
        startedAt: r.startedAt,
        completedAt: r.completedAt,
        processingMs: r.processingMs,
        topPrediction: PredictionResult(
          classId: topPredMap['classId'] as String,
          className: topPredMap['className'] as String,
          scientificName: topPredMap['scientificName'] as String,
          confidence: (topPredMap['confidence'] as num).toDouble(),
          morphologicalFeatures:
              topPredMap['morphologicalFeatures'] as String? ?? '',
        ),
        allPredictions: allPredsList,
        annotations: annotationsByRun[r.id] ?? const [],
        reviewStatus: status,
        reviewerNotes: r.reviewerNotes,
        correctedClass: r.correctedClass,
        isSimulated: r.isSimulated,
      );
      analysisByImage[r.imageId] = run;
    }

    // Map images by session ID
    final imagesBySession = <String, List<MicroscopyImage>>{};
    for (final img in imageRows) {
      final warnings = (jsonDecode(img.qualityWarningsJson) as List<dynamic>)
          .map((e) => e.toString())
          .toList();

      final mImage = MicroscopyImage(
        id: img.id,
        sessionId: img.sessionId,
        fieldIndex: img.fieldIndex,
        assetPath: img.assetPath,
        derivedPath: img.derivedPath,
        capturedAt: img.capturedAt,
        width: img.width,
        height: img.height,
        captureProfile: img.captureProfile,
        isUsable: img.isUsable,
        recaptureNeeded: img.recaptureNeeded,
        notes: img.notes,
        qualityMetrics: QualityMetrics(
          laplacianSharpness: img.laplacianSharpness,
          meanLuminance: img.meanLuminance,
          contrastRatio: img.contrastRatio,
          fovCircularCoverage: img.fovCircularCoverage,
          isPassed: img.isQualityPassed,
          warnings: warnings,
        ),
        analysisRun: analysisByImage[img.id],
      );
      imagesBySession.putIfAbsent(img.sessionId, () => []).add(mImage);
    }

    return sessionRows.map((s) {
      final status = SessionStatus.values.firstWhere(
        (e) => e.name == s.status,
        orElse: () => SessionStatus.inProgress,
      );

      final imgs = List<MicroscopyImage>.from(imagesBySession[s.id] ?? const [])
        ..sort((a, b) => a.fieldIndex.compareTo(b.fieldIndex));

      return MicroscopySession(
        id: s.id,
        title: s.title,
        specimenCode: s.specimenCode,
        specimenType: s.specimenType,
        moduleId: s.moduleId,
        moduleName: s.moduleName,
        captureProfile: s.captureProfile,
        createdAt: s.createdAt,
        operatorLabel: s.operatorLabel,
        notes: s.notes,
        status: status,
        images: imgs,
      );
    }).toList();
  }

  /// Insert or update a session along with its images and runs
  Future<void> saveSession(MicroscopySession session) async {
    await transaction(() async {
      await into(sessionsTable).insertOnConflictUpdate(
        SessionsTableCompanion.insert(
          id: session.id,
          title: session.title,
          specimenCode: session.specimenCode,
          specimenType: session.specimenType,
          moduleId: session.moduleId,
          moduleName: session.moduleName,
          captureProfile: Value(session.captureProfile),
          createdAt: session.createdAt,
          operatorLabel: Value(session.operatorLabel),
          notes: Value(session.notes),
          status: Value(session.status.name),
        ),
      );

      for (final img in session.images) {
        await saveImage(img);
      }
    });
  }

  /// Save an image record
  Future<void> saveImage(MicroscopyImage image) async {
    await transaction(() async {
      await into(imagesTable).insertOnConflictUpdate(
        ImagesTableCompanion.insert(
          id: image.id,
          sessionId: image.sessionId,
          fieldIndex: image.fieldIndex,
          assetPath: image.assetPath,
          derivedPath: Value(image.derivedPath),
          capturedAt: image.capturedAt,
          width: Value(image.width),
          height: Value(image.height),
          captureProfile: Value(image.captureProfile),
          isUsable: Value(image.isUsable),
          recaptureNeeded: Value(image.recaptureNeeded),
          notes: Value(image.notes),
          laplacianSharpness: image.qualityMetrics.laplacianSharpness,
          meanLuminance: image.qualityMetrics.meanLuminance,
          contrastRatio: image.qualityMetrics.contrastRatio,
          fovCircularCoverage: image.qualityMetrics.fovCircularCoverage,
          isQualityPassed: image.qualityMetrics.isPassed,
          qualityWarningsJson: Value(jsonEncode(image.qualityMetrics.warnings)),
        ),
      );

      if (image.analysisRun != null) {
        await saveAnalysisRun(image.analysisRun!);
      }
    });
  }

  /// Save analysis run and its annotations
  Future<void> saveAnalysisRun(AnalysisRun run) async {
    await transaction(() async {
      final topPredJson = jsonEncode({
        'classId': run.topPrediction.classId,
        'className': run.topPrediction.className,
        'scientificName': run.topPrediction.scientificName,
        'confidence': run.topPrediction.confidence,
        'morphologicalFeatures': run.topPrediction.morphologicalFeatures,
      });

      final allPredsJson = jsonEncode(
        run.allPredictions
            .map(
              (p) => {
                'classId': p.classId,
                'className': p.className,
                'scientificName': p.scientificName,
                'confidence': p.confidence,
                'morphologicalFeatures': p.morphologicalFeatures,
              },
            )
            .toList(),
      );

      await into(analysisRunsTable).insertOnConflictUpdate(
        AnalysisRunsTableCompanion.insert(
          id: run.id,
          imageId: run.imageId,
          modelId: run.modelId,
          modelVersion: run.modelVersion,
          taskType: run.taskType,
          startedAt: run.startedAt,
          completedAt: run.completedAt,
          processingMs: run.processingMs,
          topPredictionJson: topPredJson,
          allPredictionsJson: Value(allPredsJson),
          reviewStatus: Value(run.reviewStatus.name),
          reviewerNotes: Value(run.reviewerNotes),
          correctedClass: Value(run.correctedClass),
          isSimulated: Value(run.isSimulated),
        ),
      );

      // Replace annotations
      await (delete(
        annotationsTable,
      )..where((t) => t.analysisRunId.equals(run.id))).go();

      for (final a in run.annotations) {
        await into(annotationsTable).insert(
          AnnotationsTableCompanion.insert(
            id: a.id,
            analysisRunId: run.id,
            classId: a.classId,
            label: a.label,
            boxX: a.boxNormalized.x,
            boxY: a.boxNormalized.y,
            boxWidth: a.boxNormalized.width,
            boxHeight: a.boxNormalized.height,
            confidence: a.confidence,
            isModelGenerated: Value(a.isModelGenerated),
            isUserModified: Value(a.isUserModified),
          ),
        );
      }
    });
  }

  /// Delete a session and cascaded images/runs/annotations
  Future<void> deleteSessionCascade(String sessionId) async {
    await (delete(sessionsTable)..where((t) => t.id.equals(sessionId))).go();
  }

  /// Delete an individual image
  Future<void> deleteImageCascade(String imageId) async {
    await (delete(imagesTable)..where((t) => t.id.equals(imageId))).go();
  }

  /// Model installations retrieval
  Future<List<ModelInstallation>> getAllModels() async {
    final rows = await select(modelInstallationsTable).get();
    return rows
        .map(
          (r) => ModelInstallation(
            modelId: r.modelId,
            name: r.name,
            version: r.version,
            moduleId: r.moduleId,
            runtime: r.runtime,
            taskType: r.taskType,
            sizeBytes: r.sizeBytes,
            sha256Checksum: r.sha256Checksum,
            isInstalled: r.isInstalled,
            installedAt: r.installedAt,
            accuracyReport: r.accuracyReport,
            inputDimensions: r.inputDimensions,
          ),
        )
        .toList();
  }

  /// Upsert model installation
  Future<void> saveModel(ModelInstallation model) async {
    await into(modelInstallationsTable).insertOnConflictUpdate(
      ModelInstallationsTableCompanion.insert(
        modelId: model.modelId,
        name: model.name,
        version: model.version,
        moduleId: model.moduleId,
        runtime: model.runtime,
        taskType: model.taskType,
        sizeBytes: model.sizeBytes,
        sha256Checksum: model.sha256Checksum,
        isInstalled: Value(model.isInstalled),
        installedAt: model.installedAt,
        accuracyReport: model.accuracyReport,
        inputDimensions: model.inputDimensions,
      ),
    );
  }

  /// Database backup: structured JSON representation
  Future<Map<String, dynamic>> exportToJson() async {
    final sessions = await getAllSessions();
    final models = await getAllModels();

    return {
      'schema_version': schemaVersion,
      'exported_at': DateTime.now().toIso8601String(),
      'sessions': sessions
          .map(
            (s) => {
              'id': s.id,
              'title': s.title,
              'specimen_code': s.specimenCode,
              'specimen_type': s.specimenType,
              'module_id': s.moduleId,
              'module_name': s.moduleName,
              'capture_profile': s.captureProfile,
              'created_at': s.createdAt.toIso8601String(),
              'operator_label': s.operatorLabel,
              'notes': s.notes,
              'status': s.status.name,
              'fields_count': s.images.length,
              'images': s.images
                  .map(
                    (img) => {
                      'id': img.id,
                      'field_index': img.fieldIndex,
                      'asset_path': img.assetPath,
                      'captured_at': img.capturedAt.toIso8601String(),
                      'quality': {
                        'sharpness': img.qualityMetrics.laplacianSharpness,
                        'luminance': img.qualityMetrics.meanLuminance,
                        'contrast': img.qualityMetrics.contrastRatio,
                        'coverage': img.qualityMetrics.fovCircularCoverage,
                        'passed': img.qualityMetrics.isPassed,
                        'warnings': img.qualityMetrics.warnings,
                      },
                      'analysis': img.analysisRun == null
                          ? null
                          : {
                              'id': img.analysisRun!.id,
                              'model_id': img.analysisRun!.modelId,
                              'version': img.analysisRun!.modelVersion,
                              'top_prediction': {
                                'class_id':
                                    img.analysisRun!.topPrediction.classId,
                                'class_name':
                                    img.analysisRun!.topPrediction.className,
                                'scientific_name': img
                                    .analysisRun!
                                    .topPrediction
                                    .scientificName,
                                'confidence':
                                    img.analysisRun!.topPrediction.confidence,
                              },
                              'review_status':
                                  img.analysisRun!.reviewStatus.name,
                              'reviewer_notes': img.analysisRun!.reviewerNotes,
                              'corrected_class':
                                  img.analysisRun!.correctedClass,
                            },
                    },
                  )
                  .toList(),
            },
          )
          .toList(),
      'models': models
          .map(
            (m) => {
              'model_id': m.modelId,
              'name': m.name,
              'version': m.version,
              'checksum': m.sha256Checksum,
              'installed': m.isInstalled,
            },
          )
          .toList(),
    };
  }

  /// Purge all user data and reset
  Future<void> purgeDatabase() async {
    await transaction(() async {
      await delete(annotationsTable).go();
      await delete(analysisRunsTable).go();
      await delete(imagesTable).go();
      await delete(sessionsTable).go();
    });
  }
}
