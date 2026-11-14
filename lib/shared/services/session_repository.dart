import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/analysis_run.dart';
import '../models/annotation.dart';
import '../models/microscopy_image.dart';
import '../models/quality_metrics.dart';
import '../models/session.dart';

final sessionRepositoryProvider =
    NotifierProvider<SessionRepositoryNotifier, List<MicroscopySession>>(
      SessionRepositoryNotifier.new,
    );

class SessionRepositoryNotifier extends Notifier<List<MicroscopySession>> {
  final _uuid = const Uuid();

  @override
  List<MicroscopySession> build() {
    return _generateSeedSessions();
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
  }

  void updateSession(MicroscopySession updated) {
    state = [
      for (final s in state)
        if (s.id == updated.id) updated else s,
    ];
  }

  void deleteSession(String sessionId) {
    state = state.where((s) => s.id != sessionId).toList();
  }

  void addImageToSession(String sessionId, MicroscopyImage image) {
    state = [
      for (final s in state)
        if (s.id == sessionId) s.copyWith(images: [...s.images, image]) else s,
    ];
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
  }

  void updateReviewStatus({
    required String sessionId,
    required String imageId,
    required ReviewStatus status,
    required String reviewerNotes,
    String? correctedClass,
  }) {
    state = [
      for (final s in state)
        if (s.id == sessionId)
          s.copyWith(
            images: [
              for (final img in s.images)
                if (img.id == imageId && img.analysisRun != null)
                  img.copyWith(
                    analysisRun: img.analysisRun!.copyWith(
                      reviewStatus: status,
                      reviewerNotes: reviewerNotes,
                      correctedClass: correctedClass,
                    ),
                  )
                else
                  img,
            ],
          )
        else
          s,
    ];
  }

  List<MicroscopySession> _generateSeedSessions() {
    final now = DateTime.now();

    // Field 1: Aspergillus niger
    final img1 = MicroscopyImage(
      id: 'field_asp_01',
      sessionId: 'session_myc_001',
      fieldIndex: 1,
      assetPath: 'assets/sample_images/microscopy_aspergillus.png',
      capturedAt: now.subtract(const Duration(minutes: 42)),
      captureProfile: '40x Achromat • Brightfield • Lactophenol Cotton Blue',
      isUsable: true,
      recaptureNeeded: false,
      notes: 'Characteristic conidiophore vesicle with biseriate radiating phialides and chains of dark globose conidia.',
      qualityMetrics: const QualityMetrics(
        laplacianSharpness: 89.2,
        meanLuminance: 0.68,
        contrastRatio: 0.82,
        fovCircularCoverage: 0.95,
        isPassed: true,
      ),
      analysisRun: AnalysisRun(
        id: 'run_001',
        imageId: 'field_asp_01',
        modelId: 'mycology_patch_classifier',
        modelVersion: '0.1.0-alpha',
        taskType: 'image_classification',
        startedAt: now.subtract(const Duration(minutes: 41)),
        completedAt: now.subtract(const Duration(minutes: 41, seconds: 58)),
        processingMs: 312,
        topPrediction: const PredictionResult(
          classId: 'H1_aspergillus_niger',
          className: 'Aspergillus niger',
          scientificName: 'Aspergillus niger van Tieghem (1867)',
          confidence: 0.934,
          morphologicalFeatures: 'Radiate head, spherical vesicle, biseriate phialides, dark brown-black conidia.',
        ),
        allPredictions: const [
          PredictionResult(
            classId: 'H1_aspergillus_niger',
            className: 'Aspergillus niger',
            scientificName: 'Aspergillus niger',
            confidence: 0.934,
            morphologicalFeatures:
                'High match to DeFungi H1 reference patches.',
          ),
          PredictionResult(
            classId: 'H4_aspergillus_fumigatus',
            className: 'Aspergillus fumigatus',
            scientificName: 'Aspergillus fumigatus',
            confidence: 0.048,
            morphologicalFeatures: 'Columnar conidial structure mismatch.',
          ),
          PredictionResult(
            classId: 'H5_penicillium',
            className: 'Penicillium chrysogenum',
            scientificName: 'Penicillium chrysogenum',
            confidence: 0.018,
            morphologicalFeatures:
                'Penicillus branching absent in primary ROI.',
          ),
        ],
        annotations: const [
          Annotation(
            id: 'ann_01',
            classId: 'conidial_head',
            label: 'Conidial Vesicle',
            boxNormalized: RectNormalized(
              x: 0.44,
              y: 0.38,
              width: 0.22,
              height: 0.22,
            ),
            confidence: 0.94,
          ),
          Annotation(
            id: 'ann_02',
            classId: 'phialide_cluster',
            label: 'Phialides & Conidia',
            boxNormalized: RectNormalized(
              x: 0.38,
              y: 0.30,
              width: 0.34,
              height: 0.36,
            ),
            confidence: 0.91,
          ),
        ],
        reviewStatus: ReviewStatus.confirmed,
        reviewerNotes: 'Morphology completely congruent with reference. Vesicle spherical, uniseriate/biseriate chains clear.',
      ),
    );

    // Field 2: Penicillium
    final img2 = MicroscopyImage(
      id: 'field_pen_02',
      sessionId: 'session_myc_001',
      fieldIndex: 2,
      assetPath: 'assets/sample_images/microscopy_penicillium.png',
      capturedAt: now.subtract(const Duration(minutes: 36)),
      captureProfile: '40x Achromat • Brightfield • Lactophenol Cotton Blue',
      isUsable: true,
      recaptureNeeded: false,
      notes: 'Secondary sector of culture slide showing brush-like penicillus branching.',
      qualityMetrics: const QualityMetrics(
        laplacianSharpness: 82.1,
        meanLuminance: 0.64,
        contrastRatio: 0.77,
        fovCircularCoverage: 0.92,
        isPassed: true,
      ),
      analysisRun: AnalysisRun(
        id: 'run_002',
        imageId: 'field_pen_02',
        modelId: 'mycology_patch_classifier',
        modelVersion: '0.1.0-alpha',
        taskType: 'image_classification',
        startedAt: now.subtract(const Duration(minutes: 35)),
        completedAt: now.subtract(const Duration(minutes: 35, seconds: 58)),
        processingMs: 298,
        topPrediction: const PredictionResult(
          classId: 'H5_penicillium',
          className: 'Penicillium chrysogenum',
          scientificName: 'Penicillium chrysogenum Thom (1910)',
          confidence: 0.887,
          morphologicalFeatures:
              'Brush-like conidiophore with metulae and phialides in whorls.',
        ),
        allPredictions: const [
          PredictionResult(
            classId: 'H5_penicillium',
            className: 'Penicillium chrysogenum',
            scientificName: 'Penicillium chrysogenum',
            confidence: 0.887,
            morphologicalFeatures:
                'Branched conidiophore structure consistent.',
          ),
          PredictionResult(
            classId: 'H1_aspergillus_niger',
            className: 'Aspergillus niger',
            scientificName: 'Aspergillus niger',
            confidence: 0.082,
            morphologicalFeatures: 'Vesicle absent, lower probability.',
          ),
        ],
        annotations: const [
          Annotation(
            id: 'ann_03',
            classId: 'penicillus',
            label: 'Penicillus Branch',
            boxNormalized: RectNormalized(
              x: 0.38,
              y: 0.32,
              width: 0.24,
              height: 0.32,
            ),
            confidence: 0.89,
          ),
        ],
        reviewStatus: ReviewStatus.pending,
        reviewerNotes: 'Pending secondary confirmation of metulae whorl count.',
      ),
    );

    final session1 = MicroscopySession(
      id: 'session_myc_001',
      title: 'Mycological Culture Review — Plate D4',
      specimenCode: 'MYC-2026-084',
      specimenType: 'Direct Culture Mount (SDA)',
      moduleId: 'module_mycology_v1',
      moduleName: 'Fungal Patch Classification',
      captureProfile: '40x Achromat • Brightfield • Lactophenol Cotton Blue',
      createdAt: now.subtract(const Duration(minutes: 45)),
      operatorLabel: 'A. Stone (Lab Lead)',
      notes: 'Environmental fungal isolate suspected contamination from biological safety cabinet filter intake.',
      status: SessionStatus.inProgress,
      images: [img1, img2],
    );

    // Session 2: Candida albicans
    final img3 = MicroscopyImage(
      id: 'field_cand_01',
      sessionId: 'session_myc_002',
      fieldIndex: 1,
      assetPath: 'assets/sample_images/microscopy_candida.png',
      capturedAt: now.subtract(const Duration(days: 1, hours: 2)),
      captureProfile: '100x Oil Immersion • Gram Stain',
      isUsable: true,
      recaptureNeeded: false,
      notes: 'Gram-positive budding blastoconidia (yeast cells) and pseudohyphae with distinct constrictions at septal junctions.',
      qualityMetrics: const QualityMetrics(
        laplacianSharpness: 91.5,
        meanLuminance: 0.71,
        contrastRatio: 0.84,
        fovCircularCoverage: 0.96,
        isPassed: true,
      ),
      analysisRun: AnalysisRun(
        id: 'run_003',
        imageId: 'field_cand_01',
        modelId: 'mycology_patch_classifier',
        modelVersion: '0.1.0-alpha',
        taskType: 'image_classification',
        startedAt: now.subtract(const Duration(days: 1, hours: 1, minutes: 58)),
        completedAt: now.subtract(
          const Duration(days: 1, hours: 1, minutes: 57),
        ),
        processingMs: 340,
        topPrediction: const PredictionResult(
          classId: 'H2_candida_albicans',
          className: 'Candida albicans',
          scientificName: 'Candida albicans (C.P. Robin) Berkhout',
          confidence: 0.948,
          morphologicalFeatures:
              'Oval budding blastoconidia with pseudohyphae chains.',
        ),
        allPredictions: const [
          PredictionResult(
            classId: 'H2_candida_albicans',
            className: 'Candida albicans',
            scientificName: 'Candida albicans',
            confidence: 0.948,
            morphologicalFeatures: 'Matches DeFungi H2 yeast morphology.',
          ),
          PredictionResult(
            classId: 'H3_trichophyton',
            className: 'Trichophyton rubrum',
            scientificName: 'Trichophyton rubrum',
            confidence: 0.035,
            morphologicalFeatures: 'Vegetative hyphae background noise.',
          ),
        ],
        annotations: const [
          Annotation(
            id: 'ann_04',
            classId: 'blastoconidia_cluster',
            label: 'Blastoconidia Cluster',
            boxNormalized: RectNormalized(
              x: 0.40,
              y: 0.36,
              width: 0.28,
              height: 0.28,
            ),
            confidence: 0.95,
          ),
        ],
        reviewStatus: ReviewStatus.confirmed,
        reviewerNotes: 'Pseudohyphal constriction and blastoconidia clusters verified by microscopist.',
      ),
    );

    final session2 = MicroscopySession(
      id: 'session_myc_002',
      title: 'Clinical Smear — Oral Cavity Swab',
      specimenCode: 'CLIN-2026-119',
      specimenType: 'Gram-Stained Smear',
      moduleId: 'module_mycology_v1',
      moduleName: 'Fungal Patch Classification',
      captureProfile: '100x Oil Immersion • Gram Stain',
      createdAt: now.subtract(const Duration(days: 1, hours: 3)),
      operatorLabel: 'M. Chen (Microbiology Spec)',
      notes: 'Diagnostic decision support investigation. High yeast count detected.',
      status: SessionStatus.reviewed,
      images: [img3],
    );

    // Session 3: Trichophyton rubrum
    final img4 = MicroscopyImage(
      id: 'field_trich_01',
      sessionId: 'session_myc_003',
      fieldIndex: 1,
      assetPath: 'assets/sample_images/microscopy_trichophyton.png',
      capturedAt: now.subtract(const Duration(days: 3)),
      captureProfile: '40x Achromat • 10% KOH Mount',
      isUsable: true,
      recaptureNeeded: false,
      notes: 'Direct mycological examination of nail scraping cleared in potassium hydroxide.',
      qualityMetrics: const QualityMetrics(
        laplacianSharpness: 76.4,
        meanLuminance: 0.61,
        contrastRatio: 0.72,
        fovCircularCoverage: 0.91,
        isPassed: true,
      ),
      analysisRun: AnalysisRun(
        id: 'run_004',
        imageId: 'field_trich_01',
        modelId: 'mycology_patch_classifier',
        modelVersion: '0.1.0-alpha',
        taskType: 'image_classification',
        startedAt: now.subtract(const Duration(days: 3)),
        completedAt: now.subtract(const Duration(days: 3)),
        processingMs: 388,
        topPrediction: const PredictionResult(
          classId: 'H3_trichophyton',
          className: 'Trichophyton rubrum',
          scientificName: 'Trichophyton rubrum (Castell.) Sabour.',
          confidence: 0.792,
          morphologicalFeatures: 'Septate hyphae with cylindrical macroconidia and tear-drop microconidia along hyphae.',
        ),
        allPredictions: const [
          PredictionResult(
            classId: 'H3_trichophyton',
            className: 'Trichophyton rubrum',
            scientificName: 'Trichophyton rubrum',
            confidence: 0.792,
            morphologicalFeatures: 'Cigar-shaped multiseptate macroconidia.',
          ),
          PredictionResult(
            classId: 'H6_microsporum',
            className: 'Microsporum canis',
            scientificName: 'Microsporum canis',
            confidence: 0.161,
            morphologicalFeatures: 'Rough wall macroconidia variance.',
          ),
        ],
        annotations: const [
          Annotation(
            id: 'ann_05',
            classId: 'macroconidia',
            label: 'Cylindrical Macroconidium',
            boxNormalized: RectNormalized(
              x: 0.35,
              y: 0.28,
              width: 0.30,
              height: 0.24,
            ),
            confidence: 0.81,
          ),
        ],
        reviewStatus: ReviewStatus.needsFurtherReview,
        reviewerNotes: 'Morphology suggests T. rubrum, but KOH clearing artifact present. Slide needs second review by senior mycologist.',
      ),
    );

    final session3 = MicroscopySession(
      id: 'session_myc_003',
      title: 'Dermatological Scraping — Subungual',
      specimenCode: 'DERM-2026-042',
      specimenType: 'Skin/Nail Scraping (10% KOH)',
      moduleId: 'module_mycology_v1',
      moduleName: 'Fungal Patch Classification',
      captureProfile: '40x Achromat • 10% KOH Mount',
      createdAt: now.subtract(const Duration(days: 3, hours: 2)),
      operatorLabel: 'R. Patel (Lab Tech)',
      notes: 'Investigating suspected onychomycosis.',
      status: SessionStatus.completed,
      images: [img4],
    );

    return [session1, session2, session3];
  }
}
