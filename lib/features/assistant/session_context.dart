import '../../shared/models/analysis_run.dart';
import '../../shared/models/session.dart';

/// Serialises a session into a compact, factual grounding block for the
/// on-device model. Kept short so small (1B) models stay coherent.
String buildSessionContext(MicroscopySession session) {
  final b = StringBuffer()
    ..writeln('Session "${session.title}" (${session.specimenCode})')
    ..writeln('Specimen type: ${session.specimenType}')
    ..writeln('Module: ${session.moduleName}')
    ..writeln('Capture profile: ${session.captureProfile}')
    ..writeln('Status: ${session.status.displayName}')
    ..writeln('Operator: ${session.operatorLabel}')
    ..writeln('Created: ${session.createdAt.toIso8601String()}')
    ..writeln('Fields captured: ${session.images.length}');

  if (session.notes.trim().isNotEmpty) {
    b.writeln('Operator notes: ${session.notes.trim()}');
  }

  if (session.images.isEmpty) {
    b.writeln('No fields have been captured yet.');
    return b.toString();
  }

  b.writeln('\nField data:');
  final images = session.images.take(8).toList();
  for (final image in images) {
    final q = image.qualityMetrics;
    b.writeln(
      '- Field #${image.fieldIndex}: sharpness ${q.laplacianSharpness.toStringAsFixed(1)}/100, '
      'luminance ${(q.meanLuminance * 100).toStringAsFixed(0)}%, '
      'contrast ${(q.contrastRatio * 100).toStringAsFixed(0)}%, '
      'circular FOV ${(q.fovCircularCoverage * 100).toStringAsFixed(0)}%, '
      'quality ${q.isPassed ? 'PASS' : 'FAIL'}'
      '${q.warnings.isEmpty ? '' : ', warnings: ${q.warnings.join('; ')}'}.',
    );

    final run = image.analysisRun;
    if (run == null) {
      b.writeln('  Analysis: not run.');
      continue;
    }
    final top = run.topPrediction;
    b.writeln(
      '  Analysis: ${top.className} (${top.scientificName}), '
      'confidence ${(top.confidence * 100).toStringAsFixed(1)}%, '
      'model ${run.modelId} v${run.modelVersion}, '
      'review ${run.reviewStatus.displayName}.',
    );
    b.writeln('  Morphology: ${top.morphologicalFeatures}');
    if (run.allPredictions.length > 1) {
      final rest = run.allPredictions
          .skip(1)
          .take(3)
          .map(
            (p) => '${p.className} ${(p.confidence * 100).toStringAsFixed(0)}%',
          )
          .join(', ');
      b.writeln('  Other candidates: $rest.');
    }
    if (run.reviewerNotes.trim().isNotEmpty) {
      b.writeln('  Reviewer notes: ${run.reviewerNotes.trim()}');
    }
  }

  if (session.images.length > images.length) {
    b.writeln(
      '(${session.images.length - images.length} further fields omitted for brevity.)',
    );
  }

  return b.toString();
}
