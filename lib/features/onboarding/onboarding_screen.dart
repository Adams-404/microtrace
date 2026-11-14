import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme/app_tokens.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
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
      badge: 'Optical workstation',
      title: 'Digitize any optical microscope',
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
      badge: 'Edge AI architecture',
      title: 'Strictly offline-first & private',
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
      badge: 'Scientific integrity',
      title: 'Human-verified laboratory review',
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

  void _next() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final isLast = _currentPage == _steps.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          color: Colors.black,
                        ),
                        child: Image.asset(
                          'assets/branding/microtrace_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.appName,
                            style: AppTypography.title(t.textPrimary)
                                .copyWith(fontSize: 13, letterSpacing: 2.2),
                          ),
                          Text(
                            'WORKSTATION SETUP',
                            style: AppTypography.technicalMono(
                              t.textMuted,
                              fontSize: 8,
                            ).copyWith(letterSpacing: 1.2),
                          ),
                        ],
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          'Skip',
                          style: AppTypography.caption(t.textMuted)
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _steps.length,
                    onPageChanged: (idx) => setState(() => _currentPage = idx),
                    itemBuilder: (context, index) =>
                        _StepView(step: _steps[index], index: index),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          for (int i = 0; i < _steps.length; i++)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 260),
                              curve: Curves.easeOutCubic,
                              margin: const EdgeInsets.only(right: 6),
                              width: _currentPage == i ? 26 : 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: _currentPage == i
                                    ? t.accent
                                    : t.borderStrong,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: _next,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(isLast ? 'Enter workstation' : 'Continue'),
                            const SizedBox(width: 8),
                            Icon(
                              isLast
                                  ? Icons.check_rounded
                                  : Icons.arrow_forward_rounded,
                              size: 17,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepView extends StatelessWidget {
  final OnboardingStep step;
  final int index;

  const _StepView({required this.step, required this.index});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusBadge(
            label: step.badge,
            type: BadgeType.humanObservation,
            icon: step.icon,
          ),
          const SizedBox(height: 18),
          Text(step.title, style: AppTypography.display(t.textPrimary)),
          const SizedBox(height: 12),
          Text(
            step.description,
            style: AppTypography.body(t.textSecondary).copyWith(fontSize: 14),
          ),
          const SizedBox(height: 26),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: t.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: t.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: t.accentSoft,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: t.accent.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Icon(step.icon, color: t.accent, size: 21),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'KEY CAPABILITIES',
                        style: AppTypography.label(t.textMuted),
                      ),
                    ),
                    Text(
                      '0${index + 1} / 03',
                      style: AppTypography.technicalMono(
                        t.textMuted,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                for (final d in step.details) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 1),
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: t.success.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            size: 11,
                            color: t.success,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            d,
                            style: AppTypography.body(t.textPrimary)
                                .copyWith(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: t.warning.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: t.warning.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 15,
                        color: t.warning,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Decision-support only. Not a standalone diagnostic device.',
                          style: AppTypography.caption(t.textSecondary)
                              .copyWith(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
