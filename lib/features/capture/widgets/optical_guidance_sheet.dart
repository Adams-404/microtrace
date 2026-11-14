import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class OpticalGuidanceSheet extends StatelessWidget {
  const OpticalGuidanceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.tune, color: AppColors.signal, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'OPTICAL ALIGNMENT PROTOCOL',
                    style: AppTypography.title(textPrimary),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12),
          _GuidanceItem(
            stepNumber: '1',
            title: 'Eyepiece Adapter Centering',
            description:
                'Ensure the smartphone camera lens is clamped squarely against the 10x eyepiece. '
                'The illuminated circle should be concentric with the graticule reticle.',
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _GuidanceItem(
            stepNumber: '2',
            title: 'Köhler Illumination & Condenser',
            description:
                'Adjust the microscope field diaphragm and substage condenser height until field '
                'luminance registers within nominal thresholds (0.50 - 0.85). Avoid glare or severe vignetting.',
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _GuidanceItem(
            stepNumber: '3',
            title: 'Fine Focus Calibration',
            description:
                'Rotate the fine-focus knob until the real-time Laplacian sharpness metric exceeds 70.0. '
                'The circular reticle indicator will turn green once focus passes the quality gate.',
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _GuidanceItem(
            stepNumber: '4',
            title: 'Multiple Representative Fields',
            description:
                'Capture between 3 to 10 distinct non-overlapping fields across the coverslip '
                'to ensure morphological representation before running batch analysis.',
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.signalDeep,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('ACKNOWLEDGE & RETURN TO PREVIEW'),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidanceItem extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String description;
  final Color textPrimary;
  final Color textSecondary;

  const _GuidanceItem({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.signal.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.signal),
            ),
            child: Text(
              stepNumber,
              style: AppTypography.technicalMono(
                AppColors.signal,
                fontSize: 11,
                weight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.title(textPrimary)
                      .copyWith(fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTypography.caption(textSecondary)
                      .copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
