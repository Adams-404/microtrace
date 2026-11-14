import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/scientific_app_bar.dart';
import '../../core/widgets/scientific_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/services/model_repository.dart';
import '../../shared/services/session_repository.dart';

class NewSessionScreen extends ConsumerStatefulWidget {
  const NewSessionScreen({super.key});

  @override
  ConsumerState<NewSessionScreen> createState() => _NewSessionScreenState();
}

class _NewSessionScreenState extends ConsumerState<NewSessionScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _specimenCodeController;
  late TextEditingController _operatorController;
  late TextEditingController _notesController;

  String _selectedSpecimenType = 'Direct Culture Mount (SDA)';
  String _selectedModuleId = AppConstants.moduleMycologyId;
  String _selectedOpticalProfile =
      '40x Achromat • Brightfield • Lactophenol Cotton Blue';

  final List<String> _specimenTypes = [
    'Direct Culture Mount (SDA)',
    'Skin Scraping (10% KOH)',
    'Nail Scraping (10% KOH)',
    'Gram-Stained Mucosal Smear',
    'Sputum Direct Examination',
    'Saline Wet Mount',
  ];

  final List<String> _opticalProfiles = [
    '40x Achromat • Brightfield • Lactophenol Cotton Blue',
    '100x Oil Immersion • Gram Stain',
    '40x Achromat • 10% KOH Mount',
    '10x Low Power Survey • Brightfield',
  ];

  @override
  void initState() {
    super.initState();
    final randomSuffix = (100 + DateTime.now().millisecond % 900).toString();
    _titleController = TextEditingController(
      text: 'Mycological Field Observation #$randomSuffix',
    );
    _specimenCodeController = TextEditingController(
      text: 'MYC-2026-$randomSuffix',
    );
    _operatorController = TextEditingController(text: 'Lab Tech (Primary)');
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _specimenCodeController.dispose();
    _operatorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final modelState = ref.read(modelRepositoryProvider);
    final selectedModule = modelState.modules.firstWhere(
      (m) => m.id == _selectedModuleId,
      orElse: () => modelState.modules.first,
    );

    ref
        .read(sessionRepositoryProvider.notifier)
        .createSession(
          title: _titleController.text.trim(),
          specimenCode: _specimenCodeController.text.trim(),
          specimenType: _selectedSpecimenType,
          moduleId: selectedModule.id,
          moduleName: selectedModule.name,
          captureProfile: _selectedOpticalProfile,
          operatorLabel: _operatorController.text.trim(),
          notes: _notesController.text.trim(),
        );

    // Retrieve the newly created session
    final createdSession = ref.read(sessionRepositoryProvider).first;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Session ${createdSession.specimenCode} initialized. Opening Capture Workspace...',
        ),
        backgroundColor: AppColors.passGreen,
      ),
    );

    // Navigate directly into Capture Workspace
    context.pushReplacement('/capture/${createdSession.id}');
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

    final modelState = ref.watch(modelRepositoryProvider);

    return Scaffold(
      appBar: const ScientificAppBar(
        title: 'New Session',
        subtitle: 'MICROSCOPY SPECIMEN REGISTRATION',
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            32 + MediaQuery.paddingOf(context).bottom,
          ),
          children: [
            // Informative Banner
            ScientificCard(
              backgroundColor: isDark
                  ? AppColors.darkSurfaceSubtle
                  : AppColors.lightSurfaceSubtle,
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.signal,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'All captured fields, quality metrics, and model evaluations will be permanently tagged with this session metadata.',
                      style: AppTypography.caption(textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Specimen Code & Title
            Text(
              'SPECIMEN & SESSION IDENTITY',
              style: AppTypography.label(textSecondary),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _specimenCodeController,
              decoration: const InputDecoration(
                labelText: 'Specimen Identifier / Slide Code *',
                hintText: 'e.g. MYC-2026-085',
                prefixIcon: Icon(Icons.qr_code_2, size: 20),
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Specimen code is mandatory'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Session Title *',
                hintText: 'e.g. Direct fungal culture mount inspection',
                prefixIcon: Icon(Icons.edit_note, size: 20),
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Session title is mandatory'
                  : null,
            ),
            const SizedBox(height: 12),

            // Specimen Type Dropdown
            DropdownButtonFormField<String>(
              value: _selectedSpecimenType,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Preparation & Specimen Type',
                prefixIcon: Icon(Icons.science_outlined, size: 20),
              ),
              dropdownColor: isDark
                  ? AppColors.darkSurface
                  : AppColors.lightSurface,
              items: _specimenTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(
                    type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body(textPrimary),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedSpecimenType = val);
              },
            ),

            const SizedBox(height: 24),

            // Analysis Module Selection
            Text(
              'ANALYSIS MODULE SELECTION',
              style: AppTypography.label(textSecondary),
            ),
            const SizedBox(height: 10),
            for (final module in modelState.modules) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ScientificCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  borderColor: _selectedModuleId == module.id
                      ? AppColors.signal
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  backgroundColor: _selectedModuleId == module.id
                      ? AppColors.signal.withOpacity(isDark ? 0.08 : 0.04)
                      : null,
                  onTap: module.isAvailable
                      ? () {
                          setState(() => _selectedModuleId = module.id);
                        }
                      : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Radio<String>(
                          value: module.id,
                          groupValue: _selectedModuleId,
                          activeColor: AppColors.signal,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          onChanged: module.isAvailable
                              ? (val) {
                                  if (val != null) {
                                    setState(() => _selectedModuleId = val);
                                  }
                                }
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    module.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.title(textPrimary)
                                        .copyWith(fontSize: 13.5),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                StatusBadge(
                                  label: module.isAvailable
                                      ? 'INSTALLED'
                                      : 'ROADMAP',
                                  type: module.isAvailable
                                      ? BadgeType.pass
                                      : BadgeType.neutral,
                                  isCompact: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              module.shortDescription,
                              style: AppTypography.caption(textSecondary)
                                  .copyWith(fontSize: 11.5, height: 1.35),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Optical & Microscope Settings
            Text(
              'OPTICAL ACQUISITION PROFILE',
              style: AppTypography.label(textSecondary),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedOpticalProfile,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Microscope Objective & Illumination',
                prefixIcon: Icon(Icons.lens_blur, size: 20),
              ),
              dropdownColor: isDark
                  ? AppColors.darkSurface
                  : AppColors.lightSurface,
              items: _opticalProfiles.map((prof) {
                return DropdownMenuItem(
                  value: prof,
                  child: Text(
                    prof,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body(textPrimary)
                        .copyWith(fontSize: 13),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedOpticalProfile = val);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _operatorController,
              decoration: const InputDecoration(
                labelText: 'Operator / Microscopist Name',
                hintText: 'e.g. Dr. H. Vance / Lab Tech A.S.',
                prefixIcon: Icon(Icons.person_outline, size: 20),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Clinical / Research Notes (Optional)',
                hintText: 'e.g. Patient scraping, KOH cleared for 20 mins, check for septate branching.',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            FilledButton(
              onPressed: _handleSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.signalDeep,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt_outlined, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'PROCEED TO CAPTURE WORKSPACE',
                        style: AppTypography.technicalMono(
                          Colors.white,
                          fontSize: 13,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
