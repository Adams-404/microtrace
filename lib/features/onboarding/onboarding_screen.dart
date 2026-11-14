import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/scientific_card.dart';
import '../../core/widgets/status_badge.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingStep> _steps = const [
    OnboardingStep(
      badge: 'OPTICAL WORKSTATION',
      title: 'Digitize Any Optical Microscope',
      description:
          'MICROTRACE transforms standard laboratory microscopes and your smartphone '
          'into a modular digital microscopy workstation using optical eyepiece adapters.',
      icon: Icons.biotech,
      details: [
        'Compatible with standard 23mm & 30mm eyepieces',
        'Works with 10x, 40x, and 100x oil immersion objectives',
        'Standardized circular field-of-view acquisition',
      ],
    ),
    OnboardingStep(
      badge: 'EDGE AI ARCHITECTURE',
      title: 'Strictly Offline-First & Private',
      description:
          'All computer-vision models run directly on your smartphone using Google LiteRT. '
          'Zero cloud dependency, zero specimen telemetry, and complete operational privacy.',
      icon: Icons.shield_outlined,
      details: [
        'Local neural inference with CPU & GPU delegates',
        'App-private local storage for all slide fields',
        'Functions without internet connection in field laboratories',
      ],
    ),
    OnboardingStep(
      badge: 'SCIENTIFIC INTEGRITY',
      title: 'Human-Verified Laboratory Review',
      description:
          'MICROTRACE is an assistive decision-support tool. AI predictions are clearly separated '
          'from verified observations and require explicit microscopist sign-off.',
      icon: Icons.verified_user_outlined,
      details: [
        'Clear separation of observations vs model inferences',
        'Full provenance tracking with model version and checksum',
        'Traceable laboratory observation and exportable reports',
      ],
    ),
  ];

  Future<void> _completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
    } catch (_) {}
    if (mounted) {
      context.go('/');
    }
  }

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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.cyan.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.cyan.withOpacity(0.5),
                          ),
                        ),
                        child: const Icon(
                          Icons.blur_circular,
                          color: AppColors.cyan,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppConstants.appName,
                        style: AppTypography.title(textPrimary)
                            .copyWith(letterSpacing: 1.2),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      'SKIP',
                      style: AppTypography.technicalMono(
                        AppColors.cyan,
                        fontSize: 12,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _steps.length,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        StatusBadge(
                          label: step.badge,
                          type: BadgeType.humanObservation,
                          icon: Icons.science_outlined,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          step.title,
                          style: AppTypography.display(textPrimary),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          step.description,
                          style: AppTypography.body(textSecondary),
                        ),
                        const SizedBox(height: 24),
                        // Illustrated Scientific Box
                        Expanded(
                          child: ScientificCard(
                            backgroundColor: isDark
                                ? AppColors.darkSurfaceSubtle
                                : AppColors.lightSurfaceSubtle,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      step.icon,
                                      color: AppColors.cyan,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'KEY CAPABILITIES',
                                      style: AppTypography.label(textSecondary),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                for (final d in step.details) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(
                                            top: 4,
                                            right: 10,
                                          ),
                                          child: Icon(
                                            Icons.check_circle_outline,
                                            size: 16,
                                            color: AppColors.passGreen,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            d,
                                            style: AppTypography.body(
                                              textPrimary,
                                            ).copyWith(fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.amber.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        size: 16,
                                        color: AppColors.warningAmber,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Decision-support only. Not a standalone diagnostic device.',
                                          style: AppTypography.caption(
                                            textSecondary,
                                          ).copyWith(fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicator and Bottom Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Step Dots
                  Row(
                    children: [
                      for (int i = 0; i < _steps.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 6),
                          width: _currentPage == i ? 24 : 8,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentPage == i
                                ? AppColors.cyan
                                : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                    ],
                  ),
                  // Next / Get Started Button
                  FilledButton(
                    onPressed: () {
                      if (_currentPage < _steps.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _completeOnboarding();
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.cyanDark,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage < _steps.length - 1
                              ? 'NEXT'
                              : 'ENTER WORKSTATION',
                          style: AppTypography.technicalMono(
                            Colors.white,
                            fontSize: 12,
                            weight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingStep {
  final String badge;
  final String title;
  final String description;
  final IconData icon;
  final List<String> details;

  const OnboardingStep({
    required this.badge,
    required this.title,
    required this.description,
    required this.icon,
    required this.details,
  });
}
