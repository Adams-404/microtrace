import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/models/microscopy_image.dart';

class FilmstripView extends StatelessWidget {
  final List<MicroscopyImage> images;
  final void Function(MicroscopyImage image) onImageSelected;
  final VoidCallback onAddField;

  const FilmstripView({
    super.key,
    required this.images,
    required this.onImageSelected,
    required this.onAddField,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        border: const Border(
          top: BorderSide(color: Color(0xFF243042), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Counter / Summary
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FIELDS',
                style: AppTypography.technicalMono(
                  Colors.white70,
                  fontSize: 10,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${images.length}',
                style: AppTypography.technicalMono(
                  AppColors.cyan,
                  fontSize: 18,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          const VerticalDivider(color: Colors.white24, width: 1),
          const SizedBox(width: 12),

          // Horizontal list of thumbnails
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onImageSelected(image),
                    child: Container(
                      width: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: image.qualityMetrics.isPassed
                              ? AppColors.passGreen
                              : AppColors.warningAmber,
                          width: 1.5,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(image.assetPath, fit: BoxFit.cover),
                          // Field number label
                          Positioned(
                            bottom: 2,
                            left: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                '#${image.fieldIndex}',
                                style: AppTypography.technicalMono(
                                  Colors.white,
                                  fontSize: 9,
                                  weight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          // Analysis badge if already run
                          if (image.analysisRun != null)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.modelPredictionPurple,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
