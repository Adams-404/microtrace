import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:microtrace/shared/services/image_quality_service.dart';

void main() {
  group('ImageQualityService Heuristics & Performance', () {
    late Uint8List sharpImageBytes;
    late Uint8List blurryImageBytes;
    late Uint8List underexposedImageBytes;
    late Uint8List overexposedImageBytes;

    setUp(() {
      // 1. Create a 400x400 sharp image with high-contrast alternating checkerboard / grid lines
      final sharp = img.Image(width: 400, height: 400);
      for (int y = 0; y < 400; y++) {
        for (int x = 0; x < 400; x++) {
          final isEdge = (x % 20 < 10) ^ (y % 20 < 10);
          final color = isEdge ? 255 : 0;
          sharp.setPixelRgb(x, y, color, color, color);
        }
      }
      sharpImageBytes = Uint8List.fromList(img.encodePng(sharp));

      // 2. Create a blurry image by heavily smoothing the image
      final blurry = img.copyResize(sharp, width: 400, height: 400);
      img.gaussianBlur(blurry, radius: 15);
      blurryImageBytes = Uint8List.fromList(img.encodePng(blurry));

      // 3. Create an underexposed (very dark) image
      final dark = img.Image(width: 300, height: 300);
      img.fill(dark, color: img.ColorRgb8(15, 15, 15));
      underexposedImageBytes = Uint8List.fromList(img.encodePng(dark));

      // 4. Create an overexposed (very bright washed out) image
      final bright = img.Image(width: 300, height: 300);
      img.fill(bright, color: img.ColorRgb8(250, 250, 250));
      overexposedImageBytes = Uint8List.fromList(img.encodePng(bright));
    });

    test(
      'Variance of Laplacian discriminates sharp vs blurry microscopy fields',
      () {
        final sharpMetrics = ImageQualityService.assessQualityFromBytes(
          sharpImageBytes,
        );
        final blurryMetrics = ImageQualityService.assessQualityFromBytes(
          blurryImageBytes,
        );

        expect(sharpMetrics.laplacianSharpness, greaterThan(70.0));
        expect(sharpMetrics.isPassed, isTrue);

        expect(
          blurryMetrics.laplacianSharpness,
          lessThan(sharpMetrics.laplacianSharpness),
        );
        expect(blurryMetrics.isPassed, isFalse);
        expect(
          blurryMetrics.warnings.any(
            (w) => w.contains('Sharpness below diagnostic threshold'),
          ),
          isTrue,
        );
      },
    );

    test('Luminance gates detect underexposure and overexposure', () {
      final darkMetrics = ImageQualityService.assessQualityFromBytes(
        underexposedImageBytes,
      );
      expect(darkMetrics.meanLuminance, lessThan(0.38));
      expect(
        darkMetrics.warnings.any((w) => w.contains('underexposed')),
        isTrue,
      );
      expect(darkMetrics.isPassed, isFalse);

      final brightMetrics = ImageQualityService.assessQualityFromBytes(
        overexposedImageBytes,
      );
      expect(brightMetrics.meanLuminance, greaterThan(0.86));
      expect(
        brightMetrics.warnings.any((w) => w.contains('overexposed')),
        isTrue,
      );
      expect(brightMetrics.isPassed, isFalse);
    });

    test('Calculates circular aperture auto-cropping squarely centered', () {
      final rectImage = img.Image(width: 600, height: 400);
      img.fill(rectImage, color: img.ColorRgb8(120, 180, 200));
      final rectBytes = Uint8List.fromList(img.encodePng(rectImage));

      final croppedBytes = ImageQualityService.cropActiveEyepieceField(
        rectBytes,
      );
      final decodedCrop = img.decodeImage(croppedBytes);

      expect(decodedCrop, isNotNull);
      expect(decodedCrop!.width, equals(400));
      expect(decodedCrop.height, equals(400));
    });

    test('Execution performance requirement: evaluates frame in <300 ms', () {
      final stopwatch = Stopwatch()..start();
      final metrics = ImageQualityService.assessQualityFromBytes(
        sharpImageBytes,
      );
      stopwatch.stop();

      expect(metrics.laplacianSharpness, greaterThan(0));
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(300),
        reason: 'Optical heuristic evaluation must execute within 300ms SLA',
      );
    });
  });
}
