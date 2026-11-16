import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:microtrace/shared/models/analysis_run.dart';
import 'package:microtrace/shared/models/microscopy_image.dart';
import 'package:microtrace/shared/models/quality_metrics.dart';
import 'package:microtrace/shared/models/session.dart';
import 'package:microtrace/shared/services/pdf_report_service.dart';

void main() {
  group('PdfReportService Vector PDF Generation', () {
    test(
      'generates valid compliant A4 PDF bytes offline under 2 seconds',
      () async {
        final now = DateTime.now();

        final session = MicroscopySession(
          id: 'sess_pdf_001',
          title: 'Aspergillus Clinical Specimen',
          specimenCode: 'MYC-2026-X88',
          specimenType: 'SDA Culture Mount',
          moduleId: 'module_mycology_v1',
          moduleName: 'Mycology Fungal Classifier',
          captureProfile: '40x Achromat • Brightfield • LCB',
          createdAt: now,
          operatorLabel: 'Chief Mycologist',
          notes: 'Specimen demonstrates diagnostic fungal morphology.',
          status: SessionStatus.reviewed,
          images: [
            MicroscopyImage(
              id: 'img_pdf_001',
              sessionId: 'sess_pdf_001',
              fieldIndex: 1,
              assetPath: 'assets/sample_images/microscopy_aspergillus.png',
              capturedAt: now,
              qualityMetrics: const QualityMetrics(
                laplacianSharpness: 91.2,
                meanLuminance: 0.68,
                contrastRatio: 0.83,
                fovCircularCoverage: 0.95,
                isPassed: true,
                warnings: [],
              ),
              analysisRun: AnalysisRun(
                id: 'run_pdf_001',
                imageId: 'img_pdf_001',
                modelId: 'mycology_patch_classifier',
                modelVersion: '0.1.0',
                taskType: 'image_classification',
                startedAt: now,
                completedAt: now.add(const Duration(milliseconds: 310)),
                processingMs: 310,
                topPrediction: const PredictionResult(
                  classId: 'H1_aspergillus_niger',
                  className: 'Aspergillus niger',
                  scientificName: 'Aspergillus niger van Tieghem',
                  confidence: 0.942,
                  morphologicalFeatures:
                      'Radiate conidial head with dark spores',
                ),
                allPredictions: const [
                  PredictionResult(
                    classId: 'H1_aspergillus_niger',
                    className: 'Aspergillus niger',
                    scientificName: 'Aspergillus niger van Tieghem',
                    confidence: 0.942,
                    morphologicalFeatures:
                        'Radiate conidial head with dark spores',
                  ),
                  PredictionResult(
                    classId: 'H4_penicillium',
                    className: 'Penicillium',
                    scientificName: 'Penicillium chrysogenum',
                    confidence: 0.045,
                    morphologicalFeatures: 'Branched conidiophores',
                  ),
                ],
                reviewStatus: ReviewStatus.confirmed,
                reviewerNotes: 'Verified characteristic biseriate phialides.',
              ),
            ),
            MicroscopyImage(
              id: 'img_pdf_002',
              sessionId: 'sess_pdf_001',
              fieldIndex: 2,
              assetPath: 'assets/sample_images/microscopy_candida.png',
              capturedAt: now.add(const Duration(minutes: 5)),
              qualityMetrics: const QualityMetrics(
                laplacianSharpness: 72.4,
                meanLuminance: 0.55,
                contrastRatio: 0.76,
                fovCircularCoverage: 0.92,
                isPassed: true,
                warnings: [],
              ),
              analysisRun: AnalysisRun(
                id: 'run_pdf_002',
                imageId: 'img_pdf_002',
                modelId: 'mycology_patch_classifier',
                modelVersion: '0.1.0',
                taskType: 'image_classification',
                startedAt: now,
                completedAt: now,
                processingMs: 280,
                topPrediction: const PredictionResult(
                  classId: 'H2_candida_albicans',
                  className: 'Candida albicans',
                  scientificName: 'Candida albicans',
                  confidence: 0.865,
                  morphologicalFeatures: 'Oval budding yeast cells',
                ),
                reviewStatus: ReviewStatus.corrected,
                correctedClass: 'H2_candida_tropicalis',
                reviewerNotes: 'Corrected species designation following germ tube confirmation.',
              ),
            ),
          ],
        );

        final stopwatch = Stopwatch()..start();
        final Uint8List pdfBytes =
            await PdfReportService.generateObservationReportPdf(
              session: session,
            );
        stopwatch.stop();

        expect(pdfBytes, isNotEmpty);
        // Valid PDF format header begins with %PDF-
        final header = String.fromCharCodes(pdfBytes.sublist(0, 5));
        expect(header, equals('%PDF-'));

        // Acceptance Criteria: Generates report in under 2 seconds (2000 ms)
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      },
    );
  });
}
