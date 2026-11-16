import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/haptics.dart';
import '../../core/widgets/microscope_reticle_overlay.dart';
import '../../core/widgets/scientific_app_bar.dart';
import '../../shared/models/microscopy_image.dart';
import '../../shared/models/session.dart';
import '../../shared/services/file_storage_service.dart';
import '../../shared/services/image_quality_service.dart';
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

class _CaptureWorkspaceScreenState extends ConsumerState<CaptureWorkspaceScreen>
    with WidgetsBindingObserver {
  final _uuid = const Uuid();

  // Hardware Camera Controller & State
  CameraController? _cameraController;
  List<CameraDescription> _availableCameras = [];
  bool _isCameraInitialized = false;
  bool _isCameraInitializing = true;
  String? _cameraErrorMessage;

  // Optical Hardware Boundaries
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 8.0;
  double _currentZoomLevel = 1.0;
  bool _isTorchOn = false;
  bool _isExposureLocked = false;
  bool _isFocusLocked = false;
  double _exposureOffset = 0.0;
  double _minExposureOffset = -2.0;
  double _maxExposureOffset = 2.0;
  double _exposureStep = 0.5;

  // UI & Optical Feed Controls
  double _sharpnessScore = 88.4;
  bool _showReticle = true;
  bool _isCapturing = false;

  // Simulated Bench Slides (used only when no hardware camera is present)
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

  // Shutter Flash Animation & Feedback
  bool _isShutterFlashing = false;
  String? _recentFeedbackMessage;
  bool _recentFeedbackPassed = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      _cameraController = null;
      if (mounted) setState(() => _isCameraInitialized = false);
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    setState(() {
      _isCameraInitializing = true;
      _cameraErrorMessage = null;
    });

    try {
      final cameras = await availableCameras();
      _availableCameras = cameras;

      if (cameras.isEmpty) {
        if (mounted) {
          setState(() {
            _isCameraInitializing = false;
            _cameraErrorMessage = 'No optical camera hardware detected. Switched to Calibration Mode.';
          });
        }
        return;
      }

      // Default to rear-facing camera for microscope eyepiece adapters
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _cameraController = controller;
      await controller.initialize();
      if (!mounted) return;

      try {
        _minAvailableZoom = await controller.getMinZoomLevel();
        _maxAvailableZoom = await controller.getMaxZoomLevel();
        _minExposureOffset = await controller.getMinExposureOffset();
        _maxExposureOffset = await controller.getMaxExposureOffset();
        final step = await controller.getExposureOffsetStepSize();
        if (step > 0) _exposureStep = step;
      } catch (_) {}

      setState(() {
        _isCameraInitialized = true;
        _isCameraInitializing = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCameraInitializing = false;
          _cameraErrorMessage =
              'Camera initialization: $e. Switched to Calibration Mode.';
        });
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_availableCameras.length <= 1) return;
    final currentIndex = _availableCameras.indexWhere(
      (c) => c.name == _cameraController?.description.name,
    );
    final nextIndex = (currentIndex + 1) % _availableCameras.length;
    final nextCamera = _availableCameras[nextIndex];

    await _cameraController?.dispose();
    final controller = CameraController(
      nextCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _cameraController = controller;
    await controller.initialize();
    if (!mounted) return;

    try {
      _minAvailableZoom = await controller.getMinZoomLevel();
      _maxAvailableZoom = await controller.getMaxZoomLevel();
    } catch (_) {}

    setState(() {});
  }

  Future<void> _setZoom(double zoom) async {
    final clamped = zoom.clamp(_minAvailableZoom, _maxAvailableZoom);
    setState(() => _currentZoomLevel = clamped);

    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        await _cameraController!.setZoomLevel(clamped);
      } catch (_) {}
    }
  }

  Future<void> _toggleTorch() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    try {
      final next = !_isTorchOn;
      await _cameraController!.setFlashMode(
        next ? FlashMode.torch : FlashMode.off,
      );
      setState(() => _isTorchOn = next);
    } catch (_) {}
  }

  Future<void> _toggleExposureLock() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    try {
      final nextLocked = !_isExposureLocked;
      await _cameraController!.setExposureMode(
        nextLocked ? ExposureMode.locked : ExposureMode.auto,
      );
      setState(() => _isExposureLocked = nextLocked);
    } catch (_) {}
  }

  Future<void> _toggleFocusLock() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    try {
      final nextLocked = !_isFocusLocked;
      await _cameraController!.setFocusMode(
        nextLocked ? FocusMode.locked : FocusMode.auto,
      );
      setState(() => _isFocusLocked = nextLocked);
    } catch (_) {}
  }

  Future<void> _adjustExposure(double delta) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    try {
      final nextOffset = (_exposureOffset + delta).clamp(
        _minExposureOffset,
        _maxExposureOffset,
      );
      await _cameraController!.setExposureOffset(nextOffset);
      setState(() => _exposureOffset = nextOffset);
    } catch (_) {}
  }

  Future<void> _triggerCapture(MicroscopySession activeSession) async {
    if (_isCapturing) return;

    Haptics.success();
    setState(() {
      _isCapturing = true;
      _isShutterFlashing = true;
    });

    try {
      Uint8List imageBytes;
      String captureSource;

      if (_isCameraInitialized && _cameraController != null) {
        final xfile = await _cameraController!.takePicture();
        imageBytes = await xfile.readAsBytes();
        captureSource =
            'CameraX Live Stream (${_cameraController!.description.name})';
      } else {
        // Fallback: Read sample calibration slide from bundle
        final currentSlide = _availableSlides[_selectedSlideIndex];
        final byteData = await rootBundle.load(currentSlide['asset']!);
        imageBytes = byteData.buffer.asUint8List();
        captureSource = '${currentSlide['magnification']} (Calibration Mount)';
      }

      // 1. Run real-time heuristic assessment on the acquired frame
      final qualityMetrics = ImageQualityService.assessQualityFromBytes(
        imageBytes,
      );

      final imageId = _uuid.v4();
      final storage = ref.read(fileStorageServiceProvider);

      // 2. Persist raw capture file to disk
      final rawFilePath = await storage.saveRawCapture(
        imageId: imageId,
        bytes: imageBytes,
      );

      // 3. Automatically crop the active circular eyepiece FOV
      final croppedBytes = ImageQualityService.cropActiveEyepieceField(
        imageBytes,
      );
      await storage.saveDerivedCrop(imageId: imageId, bytes: croppedBytes);

      // 4. Construct immutable MicroscopyImage record
      final fieldIdx = activeSession.images.length + 1;
      final newImage = MicroscopyImage(
        id: imageId,
        sessionId: activeSession.id,
        fieldIndex: fieldIdx,
        assetPath: rawFilePath,
        capturedAt: DateTime.now(),
        captureProfile: captureSource,
        qualityMetrics: qualityMetrics,
        notes:
            'Field #$fieldIdx acquired. Zoom: ${_currentZoomLevel.toStringAsFixed(1)}x, '
            'Sharpness: ${qualityMetrics.laplacianSharpness.toStringAsFixed(1)} '
            '(${qualityMetrics.isPassed ? "PASS" : "WARN"}).',
      );

      // 5. Commit to Drift SQLite database
      ref
          .read(sessionRepositoryProvider.notifier)
          .addImageToSession(activeSession.id, newImage);

      final statusLabel = qualityMetrics.isPassed ? 'PASS' : 'WARN';
      final warningNote = qualityMetrics.warnings.isNotEmpty
          ? ' • ${qualityMetrics.warnings.first}'
          : '';

      if (mounted) {
        setState(() {
          _sharpnessScore = qualityMetrics.laplacianSharpness;
          _recentFeedbackPassed = qualityMetrics.isPassed;
          _recentFeedbackMessage =
              'Field #$fieldIdx Acquired • Sharpness: ${qualityMetrics.laplacianSharpness.toStringAsFixed(1)} ($statusLabel)$warningNote';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _recentFeedbackPassed = false;
          _recentFeedbackMessage = 'Capture error: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isShutterFlashing = false;
          _isCapturing = false;
        });
      }
    }

    // Auto dismiss feedback banner after 4.0s
    Future.delayed(const Duration(milliseconds: 4000), () {
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

  MicroscopySession _resolveOrCreateActiveSession(
    List<MicroscopySession> sessions,
  ) {
    if (widget.sessionId != null) {
      final found = sessions.where((s) => s.id == widget.sessionId).firstOrNull;
      if (found != null) return found;
    }

    if (sessions.isNotEmpty) {
      return sessions.first;
    }

    // No sessions exist in database: create a real initial session in SQLite
    return ref
        .read(sessionRepositoryProvider.notifier)
        .createSession(
          title: 'Direct Optical Acquisition',
          specimenCode:
              'SPEC-LIVE-${DateTime.now().millisecondsSinceEpoch % 10000}',
          specimenType: 'KOH Wet Mount',
          moduleId: AppConstants.moduleMycologyId,
          moduleName: 'Fungal Patch Classification',
          captureProfile: '40x Achromat • Brightfield',
          operatorLabel: 'Bench Operator',
          notes: 'Session created directly from capture workspace.',
        );
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(sessionRepositoryProvider);
    final activeSession = _resolveOrCreateActiveSession(sessions);
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
              color: AppColors.signal,
              size: 20,
            ),
            onPressed: _showGuidanceModal,
          ),
          IconButton(
            tooltip: 'Toggle Graticule & Reticle',
            icon: Icon(
              _showReticle ? Icons.grid_on : Icons.grid_off,
              color: _showReticle ? AppColors.signal : Colors.white60,
              size: 20,
            ),
            onPressed: () => setState(() => _showReticle = !_showReticle),
          ),
          TextButton(
            onPressed: () => context.push('/session/${activeSession.id}'),
            child: Text(
              'FINISH',
              style: AppTypography.technicalMono(
                AppColors.signal,
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
          // Central Optical Viewport with Hardware Preview or Calibration Slide
          InteractiveViewer(
            minScale: 1.0,
            maxScale: 5.0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Hardware Camera Preview or Calibration Mount
                  if (_isCameraInitialized && _cameraController != null)
                    AspectRatio(
                      aspectRatio: 1.0 / _cameraController!.value.aspectRatio,
                      child: CameraPreview(_cameraController!),
                    )
                  else
                    Transform.scale(
                      scale: _currentZoomLevel,
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
                    opticalProfile: _isCameraInitialized
                        ? 'CameraX • ${_currentZoomLevel.toStringAsFixed(1)}x'
                        : currentSlide['magnification']!,
                    isSimulated: !_isCameraInitialized,
                  ),
                ],
              ),
            ),
          ),

          // Shutter Flash Animation Effect
          if (_isShutterFlashing)
            Container(color: Colors.white.withOpacity(0.85)),

          // Camera Initialization Spinner
          if (_isCameraInitializing)
            Positioned(
              top: 16,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withOpacity(0.92),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.signal.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.signal,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'INITIALIZING CAMERAX SENSOR STREAM...',
                      style: AppTypography.technicalMono(
                        AppColors.signal,
                        fontSize: 10,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Calibration Mode Notice (when running in web/emulator/no-camera environment)
          if (!_isCameraInitialized &&
              !_isCameraInitializing &&
              _recentFeedbackMessage == null)
            Positioned(
              top: 16,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withOpacity(0.92),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.signal.withOpacity(0.35)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.science,
                      color: AppColors.signal,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _cameraErrorMessage ??
                            'BENCH CALIBRATION / TEST SLIDE MODE',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.technicalMono(
                          Colors.white70,
                          fontSize: 10,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

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
                    border: Border.all(
                      color: _recentFeedbackPassed
                          ? AppColors.passGreen
                          : AppColors.warningAmber,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _recentFeedbackPassed
                            ? Icons.check_circle
                            : Icons.warning_amber_rounded,
                        color: _recentFeedbackPassed
                            ? AppColors.passGreen
                            : AppColors.warningAmber,
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

          // Right Vertical Optical Floating Controls (Zoom, Torch, Locks, Exposure)
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
                const SizedBox(height: 12),

                // Optical Hardware Controls (Torch, Focus Lock, Exposure Lock)
                _buildFloatingControlGroup(
                  children: [
                    // Torch
                    IconButton(
                      tooltip: 'Toggle Illumination Torch',
                      icon: Icon(
                        _isTorchOn ? Icons.flash_on : Icons.flash_off,
                        color: _isTorchOn ? AppColors.signal : Colors.white60,
                        size: 18,
                      ),
                      onPressed: _toggleTorch,
                    ),
                    const Divider(color: Colors.white24, height: 1),

                    // Focus Lock
                    IconButton(
                      tooltip: _isFocusLocked ? 'Unlock Focus' : 'Lock Focus',
                      icon: Icon(
                        _isFocusLocked
                            ? Icons.center_focus_strong
                            : Icons.center_focus_weak,
                        color: _isFocusLocked
                            ? AppColors.passGreen
                            : Colors.white60,
                        size: 18,
                      ),
                      onPressed: _toggleFocusLock,
                    ),
                    const Divider(color: Colors.white24, height: 1),

                    // Exposure Lock
                    IconButton(
                      tooltip: _isExposureLocked
                          ? 'Unlock Exposure'
                          : 'Lock Exposure',
                      icon: Icon(
                        _isExposureLocked ? Icons.lock : Icons.lock_open,
                        color: _isExposureLocked
                            ? AppColors.passGreen
                            : Colors.white60,
                        size: 18,
                      ),
                      onPressed: _toggleExposureLock,
                    ),
                    const Divider(color: Colors.white24, height: 1),

                    // Exposure offset step
                    IconButton(
                      tooltip: 'Exposure +0.5 EV',
                      icon: const Icon(
                        Icons.exposure_plus_1,
                        color: Colors.white70,
                        size: 16,
                      ),
                      onPressed: () => _adjustExposure(_exposureStep),
                    ),
                    IconButton(
                      tooltip: 'Exposure -0.5 EV',
                      icon: const Icon(
                        Icons.exposure_neg_1,
                        color: Colors.white70,
                        size: 16,
                      ),
                      onPressed: () => _adjustExposure(-_exposureStep),
                    ),
                    if (_availableCameras.length > 1) ...[
                      const Divider(color: Colors.white24, height: 1),
                      IconButton(
                        tooltip: 'Switch Camera Sensor',
                        icon: const Icon(
                          Icons.cameraswitch,
                          color: Colors.white70,
                          size: 16,
                        ),
                        onPressed: _switchCamera,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),

                // Slide Stage Selector (active in calibration mode)
                if (!_isCameraInitialized)
                  _buildFloatingControlGroup(
                    children: [
                      IconButton(
                        tooltip: 'Next Calibration Specimen',
                        icon: const Icon(
                          Icons.swap_horiz,
                          color: AppColors.signal,
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
            bottom:
                (widget.sessionId == null ? 88.0 : 0.0) +
                MediaQuery.viewPaddingOf(context).bottom,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Filmstrip of captured fields (positioned above shutter)
                FilmstripView(
                  images: activeSession.images,
                  onImageSelected: (image) {
                    context.push(
                      '/session/${activeSession.id}/image/${image.id}',
                    );
                  },
                  onAddField: () => _triggerCapture(activeSession),
                ),

                // Shutter Action Bar
                Container(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    12,
                    16,
                    widget.sessionId == null ? 12 : 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.92),
                    border: const Border(
                      top: BorderSide(color: Color(0xFF1E293B), width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Active feed label
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _isCameraInitialized
                                  ? 'OPTICAL CAMERAX FEED'
                                  : 'CALIBRATION TARGET',
                              style: AppTypography.label(Colors.white60),
                            ),
                            Text(
                              _isCameraInitialized
                                  ? '${_currentZoomLevel.toStringAsFixed(1)}x • ${_cameraController?.description.name ?? "Camera"}'
                                  : currentSlide['name']!,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _isCapturing
                              ? null
                              : () => _triggerCapture(activeSession),
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
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isCapturing
                                      ? Colors.grey
                                      : AppColors.signal,
                                ),
                                child: _isCapturing
                                    ? const Padding(
                                        padding: EdgeInsets.all(14),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.black,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.camera,
                                        color: Colors.black,
                                        size: 28,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Review Fields Button
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: FilledButton.tonal(
                              onPressed: () =>
                                  context.push('/session/${activeSession.id}'),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF1E293B),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.checklist,
                                    size: 16,
                                    color: AppColors.signal,
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
                          ),
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
    final isSelected = _currentZoomLevel == zoom;
    return InkWell(
      onTap: () => _setZoom(zoom),
      child: Container(
        height: 36,
        alignment: Alignment.center,
        color: isSelected
            ? AppColors.signal.withOpacity(0.25)
            : Colors.transparent,
        child: Text(
          label,
          style: AppTypography.technicalMono(
            isSelected ? AppColors.signal : Colors.white70,
            fontSize: 11,
            weight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
