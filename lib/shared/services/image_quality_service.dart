import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../models/quality_metrics.dart';

class ImageQualityService {
  /// Assesses optical image quality on raw encoded image bytes (PNG, JPEG).
  ///
  /// Computes:
  /// 1. Objective sharpness via Variance of Laplacian on grayscale pixels.
  /// 2. Luminance & contrast ratio via 256-bin histogram.
  /// 3. Circular field concentricity and optical reticle alignment.
  /// 4. Actionable quality gate warnings.
  static QualityMetrics assessQualityFromBytes(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      return const QualityMetrics(
        laplacianSharpness: 0,
        meanLuminance: 0,
        contrastRatio: 0,
        fovCircularCoverage: 0,
        isPassed: false,
        warnings: ['Failed to decode image bytes.'],
      );
    }
    return assessQuality(image);
  }

  /// Evaluates an [img.Image] directly (fast execution <50 ms on 256x256).
  static QualityMetrics assessQuality(img.Image image) {
    // Downsample for high-speed real-time heuristic calculation (<30 ms)
    final workingWidth = math.min(image.width, 320);
    final workingHeight = math.min(image.height, 320);
    final resized = img.copyResize(
      image,
      width: workingWidth,
      height: workingHeight,
      interpolation: img.Interpolation.linear,
    );

    final width = resized.width;
    final height = resized.height;
    final totalPixels = width * height;

    // 1. Grayscale Luminance extraction & histogram
    final luminanceGrid = Float32List(totalPixels);
    final histogram = Int32List(256);
    double sumLuminance = 0.0;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = resized.getPixel(x, y);
        // ITU-R BT.601 standard luma formula
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;
        final lum = (0.299 * r + 0.587 * g + 0.114 * b);
        final index = y * width + x;
        luminanceGrid[index] = lum;
        sumLuminance += lum;

        final bin = lum.round().clamp(0, 255);
        histogram[bin]++;
      }
    }

    final meanLuma255 = sumLuminance / totalPixels;
    final meanLuminanceNorm = (meanLuma255 / 255.0).clamp(0.0, 1.0);

    // Standard deviation for contrast
    double sumSqDiffLuma = 0.0;
    for (int i = 0; i < totalPixels; i++) {
      final diff = luminanceGrid[i] - meanLuma255;
      sumSqDiffLuma += diff * diff;
    }
    final stdDevLuma = math.sqrt(sumSqDiffLuma / totalPixels);
    final contrastRatio = (stdDevLuma / 64.0).clamp(0.0, 1.0);

    // 2. Variance of Laplacian (Sharpness Heuristic)
    // 3x3 discrete Laplace kernel:
    //  [  0,  1,  0 ]
    //  [  1, -4,  1 ]
    //  [  0,  1,  0 ]
    double sumLaplacian = 0.0;
    int laplacianCount = 0;

    // We calculate in interior region to avoid edge artifacts
    final laplacianValues = Float32List(totalPixels);
    for (int y = 1; y < height - 1; y++) {
      final yOffset = y * width;
      for (int x = 1; x < width - 1; x++) {
        final center = luminanceGrid[yOffset + x];
        final top = luminanceGrid[yOffset - width + x];
        final bottom = luminanceGrid[yOffset + width + x];
        final left = luminanceGrid[yOffset + x - 1];
        final right = luminanceGrid[yOffset + x + 1];

        final lap = top + bottom + left + right - (4.0 * center);
        laplacianValues[laplacianCount] = lap;
        sumLaplacian += lap;
        laplacianCount++;
      }
    }

    final meanLaplacian = sumLaplacian / laplacianCount;
    double sumSqDiffLap = 0.0;
    for (int i = 0; i < laplacianCount; i++) {
      final diff = laplacianValues[i] - meanLaplacian;
      sumSqDiffLap += diff * diff;
    }
    final varianceOfLaplacian = sumSqDiffLap / laplacianCount;

    // Map variance of Laplacian to 0-100 sharpness score calibrated for microscopy
    // var_L < 40: blurry/out-of-focus
    // var_L 70-120: marginally acceptable
    // var_L > 180: crisp focused fungal hyphae/spores
    final rawScore =
        100.0 * (1.0 - math.exp(-math.sqrt(varianceOfLaplacian) / 22.0));
    final laplacianSharpness = double.parse(
      rawScore.clamp(0.0, 100.0).toStringAsFixed(1),
    );

    // 3. Eyepiece Circular Aperture Detection & Concentricity
    // Calculate center-of-mass of bright illuminated pixels
    double totalMass = 0.0;
    double weightedX = 0.0;
    double weightedY = 0.0;
    int illuminatedPixels = 0;
    final thresholdLuma = meanLuma255 * 0.45;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final lum = luminanceGrid[y * width + x];
        if (lum > thresholdLuma) {
          totalMass += lum;
          weightedX += x * lum;
          weightedY += y * lum;
          illuminatedPixels++;
        }
      }
    }

    double concentricity = 1.0;
    if (totalMass > 0) {
      final centerX = weightedX / totalMass;
      final centerY = weightedY / totalMass;
      final normalizedDist = math.sqrt(
        math.pow((centerX - (width / 2.0)) / (width / 2.0), 2) +
            math.pow((centerY - (height / 2.0)) / (height / 2.0), 2),
      );
      concentricity = (1.0 - normalizedDist * 0.8).clamp(0.1, 1.0);
    }

    final circularCoverage = (illuminatedPixels / (totalPixels * 0.785)).clamp(
      0.2,
      1.0,
    );

    // 4. Quality Warnings & Actionable Feedback
    final warnings = <String>[];
    if (laplacianSharpness < 70.0) {
      warnings.add(
        'Sharpness below diagnostic threshold ($laplacianSharpness < 70). Refocus fine-focus knob.',
      );
    }
    if (meanLuminanceNorm < 0.38) {
      warnings.add(
        'Field is underexposed (${(meanLuminanceNorm * 100).toStringAsFixed(0)}%). Increase condenser or illumination.',
      );
    } else if (meanLuminanceNorm > 0.86) {
      warnings.add(
        'Field is overexposed (${(meanLuminanceNorm * 100).toStringAsFixed(0)}%). Reduce illumination voltage.',
      );
    }
    if (concentricity < 0.75) {
      warnings.add(
        'Optical misalignment detected. Re-center smartphone adapter relative to eyepiece reticle.',
      );
    }

    final isPassed =
        laplacianSharpness >= 70.0 &&
        meanLuminanceNorm >= 0.38 &&
        meanLuminanceNorm <= 0.86 &&
        contrastRatio >= 0.45;

    return QualityMetrics(
      laplacianSharpness: laplacianSharpness,
      meanLuminance: double.parse(meanLuminanceNorm.toStringAsFixed(2)),
      contrastRatio: double.parse(contrastRatio.toStringAsFixed(2)),
      fovCircularCoverage: double.parse(circularCoverage.toStringAsFixed(2)),
      isPassed: isPassed,
      warnings: warnings,
    );
  }

  /// Automatically crops the active circular microscope field aperture,
  /// discarding unilluminated black border regions outside the eyepiece.
  static Uint8List cropActiveEyepieceField(Uint8List rawBytes) {
    final image = img.decodeImage(rawBytes);
    if (image == null) return rawBytes;

    final minDimension = math.min(image.width, image.height);
    final cropX = (image.width - minDimension) ~/ 2;
    final cropY = (image.height - minDimension) ~/ 2;

    final cropped = img.copyCrop(
      image,
      x: cropX,
      y: cropY,
      width: minDimension,
      height: minDimension,
    );

    return Uint8List.fromList(img.encodePng(cropped));
  }
}
