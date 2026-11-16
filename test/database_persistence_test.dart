import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:microtrace/shared/database/app_database.dart';
import 'package:microtrace/shared/models/analysis_run.dart';
import 'package:microtrace/shared/models/annotation.dart';
import 'package:microtrace/shared/models/microscopy_image.dart';
import 'package:microtrace/shared/models/model_installation.dart';
import 'package:microtrace/shared/models/quality_metrics.dart';
import 'package:microtrace/shared/models/session.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    // Spin up an isolated in-memory SQLite database instance for testing
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift Offline SQLite Persistence', () {
    test(
      'persists and retrieves full session hierarchy with integrity',
      () async {
        final now = DateTime.now();

        final session = MicroscopySession(
          id: 'sess_test_001',
          title: 'Aspergillus Verification Run',
          specimenCode: 'MYC-2026-X01',
          specimenType: 'Culture Mount',
          moduleId: 'module_mycology_v1',
          moduleName: 'Mycology Classifier',
          captureProfile: '40x Achromat • LCB',
          createdAt: now,
          operatorLabel: 'Lead Mycologist',
          notes: 'Initial test of database persistence',
          status: SessionStatus.inProgress,
          images: [
            MicroscopyImage(
              id: 'img_test_001',
              sessionId: 'sess_test_001',
              fieldIndex: 1,
              assetPath: 'assets/sample_images/microscopy_aspergillus.png',
              capturedAt: now,
              qualityMetrics: const QualityMetrics(
                laplacianSharpness: 92.5,
                meanLuminance: 0.65,
                contrastRatio: 0.81,
                fovCircularCoverage: 0.96,
                isPassed: true,
                warnings: [],
              ),
              analysisRun: AnalysisRun(
                id: 'run_test_001',
                imageId: 'img_test_001',
                modelId: 'mycology_patch_classifier',
                modelVersion: '0.1.0',
                taskType: 'image_classification',
                startedAt: now,
                completedAt: now.add(const Duration(milliseconds: 250)),
                processingMs: 250,
                topPrediction: const PredictionResult(
                  classId: 'H1_aspergillus_niger',
                  className: 'Aspergillus niger',
                  scientificName: 'Aspergillus niger',
                  confidence: 0.942,
                  morphologicalFeatures:
                      'Biseriate phialides and globose conidia',
                ),
                allPredictions: const [
                  PredictionResult(
                    classId: 'H1_aspergillus_niger',
                    className: 'Aspergillus niger',
                    scientificName: 'Aspergillus niger',
                    confidence: 0.942,
                    morphologicalFeatures:
                        'Biseriate phialides and globose conidia',
                  ),
                  PredictionResult(
                    classId: 'H4_penicillium',
                    className: 'Penicillium',
                    scientificName: 'Penicillium chrysogenum',
                    confidence: 0.051,
                    morphologicalFeatures: 'Brush-like conidiophores',
                  ),
                ],
                annotations: const [
                  Annotation(
                    id: 'ann_test_001',
                    classId: 'H1_aspergillus_niger',
                    label: 'Aspergillus conidiophore',
                    boxNormalized: RectNormalized(
                      x: 0.2,
                      y: 0.25,
                      width: 0.5,
                      height: 0.45,
                    ),
                    confidence: 0.94,
                    isModelGenerated: true,
                    isUserModified: false,
                  ),
                ],
                reviewStatus: ReviewStatus.pending,
                reviewerNotes: '',
              ),
            ),
          ],
        );

        // Save to database
        await db.saveSession(session);

        // Read back
        final retrieved = await db.getAllSessions();
        expect(retrieved.length, equals(1));

        final first = retrieved.first;
        expect(first.id, equals('sess_test_001'));
        expect(first.specimenCode, equals('MYC-2026-X01'));
        expect(first.status, equals(SessionStatus.inProgress));
        expect(first.images.length, equals(1));

        final image = first.images.first;
        expect(image.id, equals('img_test_001'));
        expect(image.qualityMetrics.laplacianSharpness, equals(92.5));
        expect(image.qualityMetrics.isPassed, isTrue);

        final run = image.analysisRun;
        expect(run, isNotNull);
        expect(run!.topPrediction.className, equals('Aspergillus niger'));
        expect(run.allPredictions.length, equals(2));
        expect(run.annotations.length, equals(1));
        expect(run.annotations.first.label, equals('Aspergillus conidiophore'));
      },
    );

    test(
      'stores human reviewer corrections separately maintaining provenance',
      () async {
        final now = DateTime.now();
        final session = MicroscopySession(
          id: 'sess_prov_001',
          title: 'Review Provenance Test',
          specimenCode: 'PROV-001',
          specimenType: 'KOH Smear',
          moduleId: 'module_mycology_v1',
          moduleName: 'Mycology Classifier',
          createdAt: now,
          images: [
            MicroscopyImage(
              id: 'img_prov_001',
              sessionId: 'sess_prov_001',
              fieldIndex: 1,
              assetPath: 'test_path.png',
              capturedAt: now,
              qualityMetrics: QualityMetrics.nominal(),
              analysisRun: AnalysisRun(
                id: 'run_prov_001',
                imageId: 'img_prov_001',
                modelId: 'mycology_patch_classifier',
                modelVersion: '0.1.0',
                taskType: 'image_classification',
                startedAt: now,
                completedAt: now,
                processingMs: 120,
                topPrediction: const PredictionResult(
                  classId: 'H1_aspergillus_niger',
                  className: 'Aspergillus niger',
                  scientificName: 'Aspergillus niger',
                  confidence: 0.88,
                  morphologicalFeatures: 'Vesicle detected',
                ),
                reviewStatus: ReviewStatus.pending,
              ),
            ),
          ],
        );

        await db.saveSession(session);

        // Now human reviewer modifies the decision to 'corrected'
        final existingRun = session.images.first.analysisRun!;
        final updatedRun = existingRun.copyWith(
          reviewStatus: ReviewStatus.corrected,
          reviewerNotes: 'Microscopist confirmed atypical Penicillium head, not Aspergillus.',
          correctedClass: 'H4_penicillium',
        );

        await db.saveAnalysisRun(updatedRun);

        final retrieved = await db.getAllSessions();
        final retrievedRun = retrieved.first.images.first.analysisRun!;

        // 1. Raw automated model predictions remain unchanged (provenance preserved)
        expect(
          retrievedRun.topPrediction.classId,
          equals('H1_aspergillus_niger'),
        );
        expect(retrievedRun.topPrediction.confidence, equals(0.88));

        // 2. Human reviewer sign-off stored separately
        expect(retrievedRun.reviewStatus, equals(ReviewStatus.corrected));
        expect(retrievedRun.correctedClass, equals('H4_penicillium'));
        expect(retrievedRun.reviewerNotes, contains('Microscopist confirmed'));
      },
    );

    test('cascades delete when session is removed', () async {
      final now = DateTime.now();
      final session = MicroscopySession(
        id: 'sess_del_001',
        title: 'Cascade Delete Test',
        specimenCode: 'DEL-001',
        specimenType: 'Mount',
        moduleId: 'mod_1',
        moduleName: 'Test Mod',
        createdAt: now,
        images: [
          MicroscopyImage(
            id: 'img_del_001',
            sessionId: 'sess_del_001',
            fieldIndex: 1,
            assetPath: 'test.png',
            capturedAt: now,
            qualityMetrics: QualityMetrics.nominal(),
          ),
        ],
      );

      await db.saveSession(session);
      expect((await db.getAllSessions()).length, equals(1));

      // Delete the session
      await db.deleteSessionCascade('sess_del_001');

      expect((await db.getAllSessions()).isEmpty, isTrue);
    });

    test(
      'exports structured JSON database backup and purges cleanly',
      () async {
        final now = DateTime.now();
        final session = MicroscopySession(
          id: 'sess_bk_001',
          title: 'Backup Test',
          specimenCode: 'BK-001',
          specimenType: 'Slide',
          moduleId: 'mod_1',
          moduleName: 'Test Mod',
          createdAt: now,
          images: [],
        );

        await db.saveSession(session);

        final backup = await db.exportToJson();
        expect(backup['schema_version'], equals(1));
        expect(backup['sessions'], isNotEmpty);
        expect(
          (backup['sessions'] as List).first['specimen_code'],
          equals('BK-001'),
        );

        // Purge database
        await db.purgeDatabase();
        expect((await db.getAllSessions()).isEmpty, isTrue);
      },
    );

    test('persists and updates model installations', () async {
      final now = DateTime.now();
      final model = ModelInstallation(
        modelId: 'test_model_v1',
        name: 'DeFungi Classifier',
        version: '1.0.0',
        moduleId: 'module_mycology_v1',
        runtime: 'Google LiteRT (Float16)',
        taskType: 'image_classification',
        sizeBytes: 12450000,
        sha256Checksum:
            'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        isInstalled: true,
        installedAt: now,
        accuracyReport: '93.5% Macro F1 on DeFungi test set',
        inputDimensions: '224x224 RGB [0..1]',
      );

      await db.saveModel(model);

      final models = await db.getAllModels();
      expect(models.length, equals(1));
      expect(models.first.modelId, equals('test_model_v1'));
      expect(models.first.isInstalled, isTrue);

      // Toggle install state
      await db.saveModel(models.first.copyWith(isInstalled: false));
      final updatedModels = await db.getAllModels();
      expect(updatedModels.first.isInstalled, isFalse);
    });

    test(
      'verifies fast querying performance (<50 ms acceptance criteria)',
      () async {
        final now = DateTime.now();
        // Insert a session
        final session = MicroscopySession(
          id: 'sess_perf_001',
          title: 'Performance Benchmark Session',
          specimenCode: 'PERF-1000',
          specimenType: 'High-Throughput Smear',
          moduleId: 'module_mycology_v1',
          moduleName: 'Mycology Classifier',
          createdAt: now,
          images: [],
        );
        await db.saveSession(session);

        // Bulk insert 100 images into SQLite
        for (int i = 1; i <= 100; i++) {
          await db.saveImage(
            MicroscopyImage(
              id: 'perf_img_$i',
              sessionId: 'sess_perf_001',
              fieldIndex: i,
              assetPath: 'assets/sample_images/microscopy_aspergillus.png',
              capturedAt: now,
              qualityMetrics: QualityMetrics.nominal(),
            ),
          );
        }

        // Benchmark read
        final stopwatch = Stopwatch()..start();
        final allSessions = await db.getAllSessions();
        stopwatch.stop();

        expect(allSessions.first.images.length, equals(100));
        // Acceptance criteria: Querying indexed fields takes under 50 ms
        expect(stopwatch.elapsedMilliseconds, lessThan(50));
      },
    );
  });
}
