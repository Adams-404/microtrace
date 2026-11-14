import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/microscope_reticle_overlay.dart';
import '../../core/widgets/scientific_app_bar.dart';
import '../../shared/models/microscopy_image.dart';
import '../../shared/models/quality_metrics.dart';
import '../../shared/models/session.dart';
import '../../shared/services/session_repository.dart';
import 'widgets/filmstrip_view.dart';
import 'widgets/optical_guidance_sheet.dart';

class CaptureWorkspaceScreen extends ConsumerStatefulWidget {
  final String? sessionId;

  const CaptureWorkspaceScreen({super.key, this.sessionId});

  @override
  ConsumerState<CaptureWorkspaceScreen> createState() =>
      _CaptureWorkspaceScreenState();
}

class _CaptureWorkspaceScreenState
    extends ConsumerState<CaptureWorkspaceScreen> {
  final _uuid = const Uuid();

  // Optical Feed Controls
  double _zoomLevel = 1.0;
  double _sharpnessScore = 88.4;
  final double _exposureAdjustment = 0.0;
  bool _showReticle = true;

  // Selected simulated specimen slide
  int _selectedSlideIndex = 0;
  final List<Map<String, String>> _availableSlides = [
    {
      'name': 'Aspergillus niger (Culture Mount)',
      'asset': 'assets/sample_images/microscopy_aspergillus.png',
      'magnification': '40x Achromat • LCB',
      'sharpness': '89.2',
    },
    {
      'name': 'Candida albicans (Smear)',
      'asset': 'assets/sample_images/microscopy_candida.png',
      'magnification': '100x Oil Immersion • Gram',
      'sharpness': '91.5',
    },
    {
      'name': 'Trichophyton rubrum (KOH Prep)',
      'asset': 'assets/sample_images/microscopy_trichophyton.png',
      'magnification': '40x Achromat • 10% KOH',
      'sharpness': '76.8',
    },
    {
      'name': 'Penicillium chrysogenum (Slide)',
      'asset': 'assets/sample_images/microscopy_penicillium.png',
      'magnification': '40x Achromat • LCB',
      'sharpness': '84.0',
    },
  ];

  // Shutter Flash Animation
  bool _isShutterFlashing = false;
  String? _recentFeedbackMessage;

  void _triggerCapture(MicroscopySession activeSession) {
    setState(() {
      _isShutterFlashing = true;
    });

    final currentSlide = _availableSlides[_selectedSlideIndex];
    final fieldIdx = activeSession.images.length + 1;
    final sharpness = double.tryParse(currentSlide['sharpness']!) ?? 85.0;

    final newImage = MicroscopyImage(
      id: _uuid.v4(),
      sessionId: activeSession.id,
      fieldIndex: fieldIdx,
      assetPath: currentSlide['asset']!,
      capturedAt: DateTime.now(),
      captureProfile: currentSlide['magnification']!,
      qualityMetrics: QualityMetrics(
        laplacianSharpness: sharpness,
        meanLuminance: (0.65 + _exposureAdjustment * 0.1).clamp(0.1, 0.99),
        contrastRatio: 0.81,
        fovCircularCoverage: 0.94,
        isPassed: sharpness >= 70.0,
      ),
      notes:
          'Captured field #$fieldIdx under ${currentSlide['magnification']}.',
    );

    ref
        .read(sessionRepositoryProvider.notifier)
        .addImageToSession(activeSession.id, newImage);

    Future.delayed(const Duration(milliseconds: 140), () {
      if (mounted) {
        setState(() {
          _isShutterFlashing = false;
          _recentFeedbackMessage =
              'Field #$fieldIdx Acquired • Focus: ${sharpness.toStringAsFixed(1)} (PASS)';
        });
      }
    });

    // Auto dismiss feedback banner after 3.5s
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted && _recentFeedbackMessage != null) {
        setState(() => _recentFeedbackMessage = null);
      }
    });
  }

  void _showGuidanceModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const OpticalGuidanceSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(sessionRepositoryProvider);

    // Resolve active session
    final activeSession = sessions.firstWhere(
      (s) => s.id == widget.sessionId,
      orElse: () => sessions.isNotEmpty ? sessions.first : _dummySession(),
    );

    final currentSlide = _availableSlides[_selectedSlideIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: ScientificAppBar(
        title: 'Capture Workspace',
        subtitle: '${activeSession.specimenCode} • ${activeSession.title}',
        actions: [
          IconButton(
            tooltip: 'Alignment Guidance',
            icon: const Icon(
              Icons.help_outline,
              color: AppColors.cyan,
              size: 20,
            ),
            onPressed: _showGuidanceModal,
          ),
          IconButton(
            tooltip: 'Toggle Graticule & Reticle',
            icon: Icon(
              _showReticle ? Icons.grid_on : Icons.grid_off,
              color: _showReticle ? AppColors.cyan : Colors.white60,
              size: 20,
            ),
            onPressed: () => setState(() => _showReticle = !_showReticle),
          ),
          TextButton(
            onPressed: () => context.push('/session/${activeSession.id}'),
            child: Text(
              'FINISH',
              style: AppTypography.technicalMono(
                AppColors.cyan,
                fontSize: 11,
                weight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Central Optical Viewport with Pinch & Zoom
          InteractiveViewer(
            minScale: 1.0,
            maxScale: 5.0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Active Microscope Field Image
                  Transform.scale(
                    scale: _zoomLevel,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.black),
                      child: Image.asset(
                        currentSlide['asset']!,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  ),

                  // Optical Reticle & Graticule Overlay
                  MicroscopeReticleOverlay(
                    showApertureRing: _showReticle,
                    showGraticule: _showReticle,
                    sharpnessScore: _sharpnessScore,
                    opticalProfile: currentSlide['magnification']!,
                    isSimulated: true,
                  ),
                ],
              ),
            ),
          ),

          // Shutter Flash Effect
          if (_isShutterFlashing)
            Container(color: Colors.white.withOpacity(0.85)),

          // Immediate Quality Feedback Toast
          if (_recentFeedbackMessage != null)
            Positioned(
              top: 16,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _recentFeedbackMessage != null ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.passGreen),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.passGreen,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _recentFeedbackMessage!,
                          style: AppTypography.technicalMono(
                            Colors.white,
                            fontSize: 11,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Right Vertical Optical Floating Controls (Zoom & Stage Slide selector)
          Positioned(
            right: 14,
            top: 70,
            child: Column(
              children: [
                // Zoom toggles
                _buildFloatingControlGroup(
                  children: [
                    _zoomButton('1.0x', 1.0),
                    const Divider(color: Colors.white24, height: 1),
                    _zoomButton('2.0x', 2.0),
                    const Divider(color: Colors.white24, height: 1),
                    _zoomButton('4.0x', 4.0),
                  ],
                ),
                const SizedBox(height: 14),

                // Slide Stage Selector (switch field)
                _buildFloatingControlGroup(
                  children: [
                    IconButton(
                      tooltip: 'Next Specimen Field',
                      icon: const Icon(
                        Icons.swap_horiz,
                        color: AppColors.cyan,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedSlideIndex =
                              (_selectedSlideIndex + 1) %
                              _availableSlides.length;
                          _sharpnessScore =
                              double.tryParse(
                                _availableSlides[_selectedSlideIndex]['sharpness']!,
                              ) ??
                              85.0;
                        });
                      },
                    ),
                    Text(
                      'STAGE',
                      style: AppTypography.technicalMono(
                        Colors.white70,
                        fontSize: 9,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Shutter Controls & Captured Fields Filmstrip
          Positioned(
            bottom: 96,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Shutter Action Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Active slide label
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'SLIDE TARGET',
                              style: AppTypography.label(Colors.white60),
                            ),
                            Text(
                              currentSlide['name']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.body(Colors.white).copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Large Scientific Shutter Button
                      GestureDetector(
                        onTap: () => _triggerCapture(activeSession),
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Container(
                              width: 54,
                              height: 54,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.cyan,
                              ),
                              child: const Icon(
                                Icons.camera,
                                color: Colors.black,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Review Fields Button
                      FilledButton.tonal(
                        onPressed: () =>
                            context.push('/session/${activeSession.id}'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF1E293B),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.checklist,
                              size: 16,
                              color: AppColors.cyan,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'REVIEW (${activeSession.images.length})',
                              style: AppTypography.technicalMono(
                                Colors.white,
                                fontSize: 10,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Filmstrip of captured fields
                FilmstripView(
                  images: activeSession.images,
                  onImageSelected: (image) {
                    context.push(
                      '/session/${activeSession.id}/image/${image.id}',
                    );
                  },
                  onAddField: () => _triggerCapture(activeSession),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingControlGroup({required List<Widget> children}) {
    return Container(
      width: 48,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  Widget _zoomButton(String label, double zoom) {
    final isSelected = _zoomLevel == zoom;
    return InkWell(
      onTap: () => setState(() => _zoomLevel = zoom),
      child: Container(
        height: 36,
        alignment: Alignment.center,
        color: isSelected
            ? AppColors.cyan.withOpacity(0.25)
            : Colors.transparent,
        child: Text(
          label,
          style: AppTypography.technicalMono(
            isSelected ? AppColors.cyan : Colors.white70,
            fontSize: 11,
            weight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  MicroscopySession _dummySession() {
    return MicroscopySession(
      id: 'default_session',
      title: 'Ad-hoc Microscopy Acquisition',
      specimenCode: 'SPEC-ADHOC',
      specimenType: 'General Mount',
      moduleId: AppConstants.moduleMycologyId,
      moduleName: 'Fungal Patch Classification',
      createdAt: DateTime.now(),
    );
  }
}
