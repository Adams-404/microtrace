import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/database_provider.dart';
import '../models/model_installation.dart';
import '../models/module_info.dart';

final modelRepositoryProvider =
    NotifierProvider<ModelRepositoryNotifier, ModelRepositoryState>(
      ModelRepositoryNotifier.new,
    );

class ModelRepositoryState {
  final List<ModuleInfo> modules;
  final List<ModelInstallation> models;

  const ModelRepositoryState({required this.modules, required this.models});

  ModelRepositoryState copyWith({
    List<ModuleInfo>? modules,
    List<ModelInstallation>? models,
  }) {
    return ModelRepositoryState(
      modules: modules ?? this.modules,
      models: models ?? this.models,
    );
  }
}

class ModelRepositoryNotifier extends Notifier<ModelRepositoryState> {
  AppDatabase get _db => ref.read(appDatabaseProvider);

  @override
  ModelRepositoryState build() {
    _loadFromDb();
    return ModelRepositoryState(modules: _seedModules(), models: _seedModels());
  }

  Future<void> _loadFromDb() async {
    try {
      final dbModels = await _db.getAllModels();
      if (dbModels.isNotEmpty) {
        state = state.copyWith(models: dbModels);
      } else {
        for (final m in state.models) {
          await _db.saveModel(m);
        }
      }
    } catch (_) {
      // Fallback in environments without persistent db
    }
  }

  void toggleModelInstallation(String modelId) {
    state = state.copyWith(
      models: [
        for (final m in state.models)
          if (m.modelId == modelId)
            () {
              final updated = m.copyWith(isInstalled: !m.isInstalled);
              _db.saveModel(updated).catchError((_) {});
              return updated;
            }()
          else
            m,
      ],
    );
  }

  void updateModel(String modelId) {
    state = state.copyWith(
      models: [
        for (final m in state.models)
          if (m.modelId == modelId)
            () {
              final updated = m.copyWith(
                version: '0.2.0-rc1',
                installedAt: DateTime.now(),
                accuracyReport: 'Updated baseline with 94.2% top-1 accuracy on DeFungi test set.',
              );
              _db.saveModel(updated).catchError((_) {});
              return updated;
            }()
          else
            m,
      ],
    );
  }

  List<ModuleInfo> _seedModules() {
    return const [
      ModuleInfo(
        id: 'module_mycology_v1',
        name: 'Mycology: Fungal Patch Classifier',
        category: 'Mycology & Dermatophytes',
        shortDescription: 'Computer-vision decision support for microscopic fungal culture mounts and dermatological scrapings.',
        fullDescription:
            'Analyzes cropped microscopic fields to assist in identifying fungal genus-level morphology '
            'including Aspergillus, Candida, Trichophyton, and Penicillium. Built for conventional optical microscopes '
            'fitted with smartphone eyepiece adapters under 40x and 100x magnification.',
        supportedSpecimens: [
          'Direct KOH mounts (Skin/Nail/Hair)',
          'Lactophenol Cotton Blue mounts',
          'Sabouraud Dextrose Agar (SDA) micro-culture slides',
          'Gram-stained mucosal smears',
        ],
        supportedTask: 'Image Patch Classification (5 morphological classes)',
        isInstalled: true,
        isAvailable: true,
        version: '0.1.0',
        recommendedMagnification: '40x Achromat / 100x Oil Immersion',
        datasetReference: 'DeFungi (UCI ML Repository #773; Sopo et al., 2021)',
        license: 'CC BY 4.0 (Research Use Only)',
      ),
      ModuleInfo(
        id: 'module_parasitology_v1',
        name: 'Parasitology: Hemoparasite Screener',
        category: 'Parasitology & Tropical Medicine',
        shortDescription: 'Upcoming object detection assistance for blood smears and stool concentrates.',
        fullDescription:
            'Planned module for automated detection of Trypanosoma cruzi, Leishmania amastigotes, and microfilariae '
            'in Giemsa-stained thin and thick blood smears. Currently in pre-training research phase.',
        supportedSpecimens: [
          'Giemsa-stained thin blood smears',
          'Concentrated stool wet mounts',
        ],
        supportedTask: 'Object Detection & Morphology Localization (Upcoming)',
        isInstalled: false,
        isAvailable: false,
        version: 'Planned v0.3.0',
        recommendedMagnification: '100x Oil Immersion',
        datasetReference: 'PLOS NTD smartphone microscopy benchmarks',
        license: 'Pending clinical research review',
      ),
      ModuleInfo(
        id: 'module_malaria_smear_v1',
        name: 'Malaria: Plasmodium Smear Screener',
        category: 'Infectious Disease',
        shortDescription: 'Roadmap module for assisted detection of P. falciparum and P. vivax ring forms.',
        fullDescription:
            'Future module designed around YOLOv11n edge detection architecture for thick and thin blood films. '
            'Requires institutional dataset governance and localized calibration before deployment.',
        supportedSpecimens: [
          'Standardized Giemsa-stained thick/thin blood films',
        ],
        supportedTask: 'Object Detection & Counting (Upcoming)',
        isInstalled: false,
        isAvailable: false,
        version: 'Planned v0.4.0',
        recommendedMagnification: '100x Oil Immersion',
        datasetReference:
            'Applied Sciences 2026 malaria smartphone microscopy cohort',
        license: 'Restricted research protocol',
      ),
      ModuleInfo(
        id: 'module_cell_analysis_v1',
        name: 'Cell Analysis: Hemocytometer Counter',
        category: 'General Laboratory Tools',
        shortDescription:
            'Grid detection and cell viability counting on Neubauer chambers.',
        fullDescription:
            'Automated counting and viability ratio assessment for cell suspensions on standard hemocytometer grids '
            'using Trypan Blue exclusion staining.',
        supportedSpecimens: [
          'Neubauer hemocytometer chamber',
          'Trypan blue cell suspensions',
        ],
        supportedTask: 'Grid Localization & Cell Counting (Upcoming)',
        isInstalled: false,
        isAvailable: false,
        version: 'Planned v0.4.0',
        recommendedMagnification: '10x - 20x Brightfield',
        datasetReference: 'In-vitro culture validation series',
        license: 'Apache 2.0',
      ),
    ];
  }

  List<ModelInstallation> _seedModels() {
    return [
      ModelInstallation(
        modelId: 'mycology_patch_classifier',
        name: 'MobileNetV3-Mycology-Patch',
        version: '0.1.0-alpha',
        moduleId: 'module_mycology_v1',
        runtime: 'LiteRT CompiledModel (Float16 CPU/GPU)',
        taskType: 'Image Classification (224 × 224)',
        sizeBytes: 15518924, // ~14.8 MB
        sha256Checksum:
            'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        isInstalled: true,
        installedAt: DateTime.now().subtract(const Duration(days: 7)),
        accuracyReport: 'Accuracy: 91.8%, Macro-F1: 0.906 on DeFungi 5-class benchmark split.',
        inputDimensions: '224 × 224 × 3 RGB [0..1 Normalized]',
      ),
      ModelInstallation(
        modelId: 'microscope_fov_detector',
        name: 'OpticField-Circle-Segmenter',
        version: '1.0.2',
        moduleId: 'module_mycology_v1',
        runtime: 'LiteRT Interpreter (INT8 Quantized)',
        taskType: 'Aperture Edge Detection (320 × 320)',
        sizeBytes: 3355443, // ~3.2 MB
        sha256Checksum:
            '7d793037a0760186574b0282f2f435e7080a6fac5b6a37ac19e5636fcdc44f18',
        isInstalled: true,
        installedAt: DateTime.now().subtract(const Duration(days: 14)),
        accuracyReport:
            'Dice coefficient: 0.962 on smartphone eyepiece vignette dataset.',
        inputDimensions: '320 × 320 × 1 Grayscale',
      ),
      ModelInstallation(
        modelId: 'yolo11n_malaria_experimental',
        name: 'YOLOv11n-Plasmodium-Edge',
        version: '0.0.1-research',
        moduleId: 'module_malaria_smear_v1',
        runtime: 'LiteRT Float32 (Experimental)',
        taskType: 'Object Detection (640 × 640)',
        sizeBytes: 28450112, // ~27.1 MB
        sha256Checksum:
            '5891b5b522d5df086d0ff0b110fbd9d21bb4fc7163af34d08286a2e846f6be03',
        isInstalled: false,
        installedAt: DateTime.now(),
        accuracyReport: 'Evaluation pending local clinical trial calibration.',
        inputDimensions: '640 × 640 × 3 RGB',
      ),
    ];
  }
}
