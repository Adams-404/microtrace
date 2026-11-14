import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/analysis_run.dart';
import '../models/annotation.dart';
import '../models/microscopy_image.dart';
import '../models/module_info.dart';

abstract interface class MicroscopyInferenceService {
  Future<AnalysisRun> runInference({
    required MicroscopyImage image,
    required ModuleInfo module,
    required void Function(double progress, String stepDescription) onProgress,
  });
}

class MockLiteRTInferenceService implements MicroscopyInferenceService {
  final _uuid = const Uuid();

  @override
  Future<AnalysisRun> runInference({
    required MicroscopyImage image,
    required ModuleInfo module,
    required void Function(double progress, String stepDescription) onProgress,
  }) async {
    final startTime = DateTime.now();

    // Stage 1: Optical Preprocessing & Vignette Localization
    onProgress(0.15, 'Detecting circular microscope field aperture (320×320)...');
    await Future.delayed(const Duration(milliseconds: 320));

    onProgress(0.35, 'Cropping active field of view & normalizing RGB [0..1]...');
    await Future.delayed(const Duration(milliseconds: 300));

    // Stage 2: Quality Gate Assessment
    onProgress(0.60, 'Evaluating Laplacian sharpness & luminance thresholds...');
    await Future.delayed(const Duration(milliseconds: 340));

    // Stage 3: LiteRT On-Device Neural Inference
    onProgress(0.85, 'Executing LiteRT CompiledModel on-device delegate...');
    await Future.delayed(const Duration(milliseconds: 400));

    onProgress(1.0, 'Decoding morphological class probabilities...');
    await Future.delayed(const Duration(milliseconds: 150));

    final completedTime = DateTime.now();
    final elapsedMs = completedTime.difference(startTime).inMilliseconds;

    // Determine realistic predictions based on image asset
    final PredictionResult topPred;
    final List<PredictionResult> allPreds;
    final List<Annotation> annotations;

    if (image.assetPath.contains('aspergillus')) {
      topPred = const PredictionResult(
        classId: 'H1_aspergillus_niger',
        className: 'Aspergillus niger',
        scientificName: 'Aspergillus niger van Tieghem (1867)',
        confidence: 0.942,
        morphologicalFeatures: 'Globose conidial head with dark biseriate phialides and chains of conidia.',
      );
      allPreds = const [
        PredictionResult(
          classId: 'H1_aspergillus_niger',
          className: 'Aspergillus niger',
          scientificName: 'Aspergillus niger',
          confidence: 0.942,
          morphologicalFeatures: 'Congruent with DeFungi H1 class.',
        ),
        PredictionResult(
          classId: 'H4_aspergillus_fumigatus',
          className: 'Aspergillus fumigatus',
          scientificName: 'Aspergillus fumigatus',
          confidence: 0.041,
          morphologicalFeatures: 'Columnar head structure mismatch.',
        ),
        PredictionResult(
          classId: 'H5_penicillium',
          className: 'Penicillium chrysogenum',
          scientificName: 'Penicillium chrysogenum',
          confidence: 0.017,
          morphologicalFeatures: 'Phialides branching profile divergent.',
        ),
      ];
      annotations = const [
        Annotation(
          id: 'ann_sim_01',
          classId: 'vesicle',
          label: 'Conidial Vesicle',
          boxNormalized: RectNormalized(x: 0.44, y: 0.38, width: 0.22, height: 0.22),
          confidence: 0.94,
        ),
        Annotation(
          id: 'ann_sim_02',
          classId: 'phialides',
          label: 'Radiating Phialides',
          boxNormalized: RectNormalized(x: 0.38, y: 0.30, width: 0.34, height: 0.36),
          confidence: 0.91,
        ),
      ];
    } else if (image.assetPath.contains('candida')) {
      topPred = const PredictionResult(
        classId: 'H2_candida_albicans',
        className: 'Candida albicans',
        scientificName: 'Candida albicans (C.P. Robin) Berkhout',
        confidence: 0.956,
        morphologicalFeatures: 'Oval budding blastoconidia clusters with distinct pseudohyphal septa constrictions.',
      );
      allPreds = const [
        PredictionResult(
          classId: 'H2_candida_albicans',
          className: 'Candida albicans',
          scientificName: 'Candida albicans',
          confidence: 0.956,
          morphologicalFeatures: 'Matches DeFungi H2 yeast morphology.',
        ),
        PredictionResult(
          classId: 'H3_trichophyton',
          className: 'Trichophyton rubrum',
          scientificName: 'Trichophyton rubrum',
          confidence: 0.029,
          morphologicalFeatures: 'Linear hyphae mismatch.',
        ),
      ];
      annotations = const [
        Annotation(
          id: 'ann_sim_03',
          classId: 'blastoconidia',
          label: 'Blastoconidia Cluster',
          boxNormalized: RectNormalized(x: 0.40, y: 0.36, width: 0.28, height: 0.28),
          confidence: 0.96,
        ),
      ];
    } else if (image.assetPath.contains('penicillium')) {
      topPred = const PredictionResult(
        classId: 'H5_penicillium',
        className: 'Penicillium chrysogenum',
        scientificName: 'Penicillium chrysogenum Thom (1910)',
        confidence: 0.894,
        morphologicalFeatures: 'Penicillus brush structure with branched metulae bearing whorls of flask-shaped phialides.',
      );
      allPreds = const [
        PredictionResult(
          classId: 'H5_penicillium',
          className: 'Penicillium chrysogenum',
          scientificName: 'Penicillium chrysogenum',
          confidence: 0.894,
          morphologicalFeatures: 'Classic penicillus brush branching.',
        ),
        PredictionResult(
          classId: 'H1_aspergillus_niger',
          className: 'Aspergillus niger',
          scientificName: 'Aspergillus niger',
          confidence: 0.078,
          morphologicalFeatures: 'Absence of spherical central vesicle.',
        ),
      ];
      annotations = const [
        Annotation(
          id: 'ann_sim_04',
          classId: 'penicillus_brush',
          label: 'Penicillus Branch',
          boxNormalized: RectNormalized(x: 0.38, y: 0.32, width: 0.24, height: 0.32),
          confidence: 0.89,
        ),
      ];
    } else {
      // Trichophyton or default
      topPred = const PredictionResult(
        classId: 'H3_trichophyton',
        className: 'Trichophyton rubrum',
        scientificName: 'Trichophyton rubrum (Castell.) Sabour.',
        confidence: 0.841,
        morphologicalFeatures: 'Narrow septate vegetative hyphae accompanied by smooth-walled cylindrical macroconidia.',
      );
      allPreds = const [
        PredictionResult(
          classId: 'H3_trichophyton',
          className: 'Trichophyton rubrum',
          scientificName: 'Trichophyton rubrum',
          confidence: 0.841,
          morphologicalFeatures: 'Cigar-shaped macroconidia detected.',
        ),
        PredictionResult(
          classId: 'H6_microsporum',
          className: 'Microsporum canis',
          scientificName: 'Microsporum canis',
          confidence: 0.112,
          morphologicalFeatures: 'Wall echinulation absent.',
        ),
      ];
      annotations = const [
        Annotation(
          id: 'ann_sim_05',
          classId: 'macroconidium',
          label: 'Macroconidium (Cigar-shaped)',
          boxNormalized: RectNormalized(x: 0.35, y: 0.28, width: 0.30, height: 0.24),
          confidence: 0.84,
        ),
      ];
    }

    return AnalysisRun(
      id: _uuid.v4(),
      imageId: image.id,
      modelId: 'mycology_patch_classifier',
      modelVersion: '0.1.0-alpha',
      taskType: 'image_classification',
      startedAt: startTime,
      completedAt: completedTime,
      processingMs: elapsedMs,
      topPrediction: topPred,
      allPredictions: allPreds,
      annotations: annotations,
      reviewStatus: ReviewStatus.pending,
      reviewerNotes: '',
      isSimulated: true,
    );
  }
}
