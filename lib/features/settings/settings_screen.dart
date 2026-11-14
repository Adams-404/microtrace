import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../app/theme/app_tokens.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/theme_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/haptics.dart';
import '../../core/widgets/app_icon_button.dart';
import '../../core/widgets/scientific_app_bar.dart';
import '../../core/widgets/scientific_card.dart';
import '../../shared/services/storage_service.dart';
import '../assistant/assistant_controller.dart';
import '../../shared/models/assistant_settings.dart';
import '../../shared/services/local_ai_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: ScientificAppBar(
        title: 'Workstation Settings',
        subtitle: 'PREFERENCES & LOCAL STORAGE',
      ),
      body: _SettingsBody(),
    );
  }
}

/// Opens workstation settings as a rounded sheet that slides up from the
/// bottom of the screen.
Future<void> showSettingsSheet(BuildContext context) {
  Haptics.tap();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.58),
    sheetAnimationStyle: const AnimationStyle(
      duration: Duration(milliseconds: 420),
      reverseDuration: Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ),
    builder: (context) =>
        const FractionallySizedBox(heightFactor: 0.94, child: SettingsSheet()),
  );
}

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Container(
      decoration: BoxDecoration(
        color: t.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: t.borderStrong,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: AppTypography.title(t.textPrimary)
                            .copyWith(fontSize: 20, letterSpacing: -0.4),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'PREFERENCES & LOCAL AI',
                        style: AppTypography.technicalMono(
                          t.textMuted,
                          fontSize: 8.5,
                          weight: FontWeight.w600,
                        ).copyWith(letterSpacing: 1.1),
                      ),
                    ],
                  ),
                ),
                AppIconButton(
                  icon: Icons.close_rounded,
                  tooltip: 'Close settings',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 18, thickness: 1),
          const Expanded(
            child: _SettingsBody(padding: EdgeInsets.fromLTRB(16, 12, 16, 28)),
          ),
        ],
      ),
    );
  }
}

class _SettingsBody extends ConsumerWidget {
  final EdgeInsets padding;

  const _SettingsBody({this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeModeProvider);
    final storage = ref.watch(storageServiceProvider);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return ListView(
      padding: padding,
      children: [
        // Appearance & Theme Section
        Text('APPEARANCE', style: AppTypography.label(textSecondary)),
        const SizedBox(height: 10),

        ScientificCard(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: _ThemeChoice(
                  label: 'Darkroom',
                  hint: 'Default',
                  mode: AppThemeMode.dark,
                  current: currentTheme,
                  swatchBg: AppColors.darkBg,
                  swatchSurface: AppColors.darkSurface,
                  onSelect: () => ref
                      .read(themeModeProvider.notifier)
                      .setTheme(AppThemeMode.dark),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _ThemeChoice(
                  label: 'AMOLED',
                  hint: 'True black',
                  mode: AppThemeMode.amoled,
                  current: currentTheme,
                  swatchBg: AppColors.amoledBg,
                  swatchSurface: AppColors.amoledSurfaceHigh,
                  onSelect: () => ref
                      .read(themeModeProvider.notifier)
                      .setTheme(AppThemeMode.amoled),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _ThemeChoice(
                  label: 'Daylight',
                  hint: 'Bright bench',
                  mode: AppThemeMode.light,
                  current: currentTheme,
                  swatchBg: AppColors.lightBg,
                  swatchSurface: AppColors.lightSurface,
                  onSelect: () => ref
                      .read(themeModeProvider.notifier)
                      .setTheme(AppThemeMode.light),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Local AI Copilot
        Text('LOCAL AI COPILOT', style: AppTypography.label(textSecondary)),
        const SizedBox(height: 10),
        const LocalAiSettingsCard(),

        const SizedBox(height: 24),

        // Local Storage Management
        Text(
          'LOCAL APP-PRIVATE STORAGE',
          style: AppTypography.label(textSecondary),
        ),
        const SizedBox(height: 10),

        ScientificCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Disk Footprint',
                    style: AppTypography.body(textPrimary),
                  ),
                  Text(
                    Formatters.formatBytes(storage.totalBytes),
                    style: AppTypography.technicalMono(
                      AppColors.signal,
                      fontSize: 13,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _storageRow(
                'SQLite Database & Sessions',
                Formatters.formatBytes(storage.databaseBytes),
                textSecondary,
              ),
              _storageRow(
                'Microscopy Slide Images',
                Formatters.formatBytes(storage.rawImagesBytes),
                textSecondary,
              ),
              _storageRow(
                'On-Device Neural Models',
                Formatters.formatBytes(storage.modelsBytes),
                textSecondary,
              ),
              _storageRow(
                'Exported PDF Reports Cache',
                Formatters.formatBytes(storage.reportsBytes),
                textSecondary,
              ),
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: () {
                  ref.read(storageServiceProvider.notifier).clearReportsCache();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reports cache purged successfully.'),
                      backgroundColor: AppColors.passGreen,
                    ),
                  );
                },
                child: const Text('PURGE REPORT CACHE'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Privacy & Offline Disclosure
        Text(
          'PRIVACY & OFFLINE ARCHITECTURE',
          style: AppTypography.label(textSecondary),
        ),
        const SizedBox(height: 10),

        ScientificCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: AppColors.passGreen,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '100% Offline-First Guarantee',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'MICROTRACE does not transmit images, patient codes, or session records over the internet. '
                'Inference is executed completely on-device through LiteRT compiled models.',
                style: AppTypography.body(textSecondary).copyWith(fontSize: 12),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Scientific Disclaimer
        Text(
          'LEGAL & SCIENTIFIC NOTICE',
          style: AppTypography.label(textSecondary),
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.gavel, color: AppColors.warningAmber, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppConstants.scientificDisclaimer,
                  style: AppTypography.caption(textSecondary)
                      .copyWith(fontSize: 11, height: 1.5),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // About MICROTRACE
        Center(
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/branding/microtrace_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${AppConstants.appName} v${AppConstants.appVersion}',
                style: AppTypography.technicalMono(textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                'Smartphone-Assisted Microscopy Workstation',
                style: AppTypography.caption(textSecondary)
                    .copyWith(fontSize: 10),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _storageRow(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption(textColor)),
          Text(
            value,
            style: AppTypography.technicalMono(textColor, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ThemeChoice extends StatelessWidget {
  final String label;
  final String hint;
  final AppThemeMode mode;
  final AppThemeMode current;
  final Color swatchBg;
  final Color swatchSurface;
  final VoidCallback onSelect;

  const _ThemeChoice({
    required this.label,
    required this.hint,
    required this.mode,
    required this.current,
    required this.swatchBg,
    required this.swatchSurface,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final selected = current == mode;
    final tokens = context.tokens;
    const accent = AppColors.signal;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Haptics.select();
          onSelect();
        },
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selected
                ? accent.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? accent.withValues(alpha: 0.45)
                  : Colors.transparent,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: swatchBg,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 18,
                      height: 4,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: swatchSurface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption(
                        selected ? accent : tokens.textPrimary,
                      ).copyWith(fontWeight: FontWeight.w600, fontSize: 11.5),
                    ),
                  ),
                  if (selected)
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 13,
                      color: AppColors.signal,
                    ),
                ],
              ),
              const SizedBox(height: 1),
              Text(
                hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption(tokens.textMuted)
                    .copyWith(fontSize: 9.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Connects the app to the phone-local OpenAI-compatible server
/// (Clearport / llama.cpp in Termux, default `http://127.0.0.1:8080/v1`).
class LocalAiSettingsCard extends ConsumerStatefulWidget {
  const LocalAiSettingsCard({super.key});

  @override
  ConsumerState<LocalAiSettingsCard> createState() =>
      _LocalAiSettingsCardState();
}

class _LocalAiSettingsCardState extends ConsumerState<LocalAiSettingsCard> {
  late final TextEditingController _baseUrl;
  late final TextEditingController _model;
  late final TextEditingController _apiKey;

  bool _testing = false;
  bool _obscure = true;
  AiStatus? _result;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(assistantSettingsProvider);
    _baseUrl = TextEditingController(text: settings.baseUrl);
    _model = TextEditingController(text: settings.model);
    _apiKey = TextEditingController(text: settings.apiKey);
  }

  @override
  void dispose() {
    _baseUrl.dispose();
    _model.dispose();
    _apiKey.dispose();
    super.dispose();
  }

  AssistantSettings get _current => AssistantSettings(
    baseUrl: AssistantSettings.normalizeBaseUrl(_baseUrl.text),
    model: _model.text.trim(),
    apiKey: _apiKey.text.trim(),
    temperature: ref.read(assistantSettingsProvider).temperature,
  );

  Future<void> _persist({bool haptic = true}) async {
    await ref.read(assistantSettingsProvider.notifier).update(_current);
    if (haptic) Haptics.select();
  }

  Future<void> _test() async {
    if (_testing) return;
    Haptics.tap();
    setState(() {
      _testing = true;
      _result = null;
    });
    await _persist(haptic: false);
    final result = await LocalAiService(_current).checkStatus();
    if (!mounted) return;
    if (result.isOnline) {
      Haptics.success();
      if (_model.text.trim().isEmpty && result.model != null) {
        _model.text = result.model!;
        await _persist(haptic: false);
      }
    } else {
      Haptics.warning();
    }
    setState(() {
      _testing = false;
      _result = result;
    });
  }

  void _resetDefaults() {
    Haptics.select();
    _baseUrl.text = AssistantSettings.defaultBaseUrl;
    _model.clear();
    _apiKey.clear();
    setState(() => _result = null);
    _persist();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return ScientificCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: t.accentSoft,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: t.accent.withValues(alpha: 0.22)),
                ),
                child: Icon(
                  Icons.auto_awesome_outlined,
                  size: 17,
                  color: t.accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'On-device model server',
                      style: AppTypography.bodyMedium(t.textPrimary)
                          .copyWith(fontSize: 13),
                    ),
                    Text(
                      'Clearport / llama.cpp · OpenAI-compatible',
                      style: AppTypography.caption(t.textMuted)
                          .copyWith(fontSize: 10.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _field(
            label: 'Base URL',
            controller: _baseUrl,
            hint: AssistantSettings.defaultBaseUrl,
            keyboardType: TextInputType.url,
            onSubmitted: (_) => _persist(),
          ),
          const SizedBox(height: 10),
          _field(
            label: 'Model ID',
            controller: _model,
            hint: 'Leave empty to use the loaded model',
            onSubmitted: (_) => _persist(),
          ),
          const SizedBox(height: 10),
          _field(
            label: 'API key (optional)',
            controller: _apiKey,
            hint: 'Only if your server requires one',
            obscure: _obscure,
            onSubmitted: (_) => _persist(),
            suffix: IconButton(
              tooltip: _obscure ? 'Show key' : 'Hide key',
              icon: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 17,
                color: t.textMuted,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _testing ? null : _test,
                  icon: _testing
                      ? SizedBox(
                          width: 13,
                          height: 13,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.8,
                            valueColor: AlwaysStoppedAnimation(t.accent),
                          ),
                        )
                      : Icon(
                          Icons.bolt_outlined,
                          size: 16,
                          color: t.textPrimary,
                        ),
                  label: Text(_testing ? 'TESTING…' : 'TEST CONNECTION'),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _resetDefaults,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  minimumSize: const Size(0, 38),
                ),
                child: const Text('RESET'),
              ),
            ],
          ),
          if (_result != null) ...[
            const SizedBox(height: 12),
            _resultBlock(t, _result!),
          ],
        ],
      ),
    );
  }

  Widget _resultBlock(AppTokens t, AiStatus status) {
    final online = status.isOnline;
    final color = online ? t.success : t.danger;

    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                online
                    ? Icons.check_circle_outline_rounded
                    : Icons.error_outline_rounded,
                size: 15,
                color: color,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  online
                      ? 'Connected${status.model == null ? '' : ' · ${status.model}'}'
                      : (status.message ?? 'Could not connect'),
                  style: AppTypography.caption(t.textPrimary)
                      .copyWith(fontSize: 11.5),
                ),
              ),
            ],
          ),
          if (!online && status.hint != null) ...[
            const SizedBox(height: 5),
            Text(
              status.hint!,
              style: AppTypography.technicalMono(
                t.textMuted,
                fontSize: 9.5,
              ).copyWith(height: 1.4),
            ),
          ],
          if (online && status.models.length > 1) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final model in status.models.take(4))
                  GestureDetector(
                    onTap: () {
                      Haptics.select();
                      _model.text = model;
                      setState(() {});
                      _persist(haptic: false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: t.surfaceHigh,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: t.border),
                      ),
                      child: Text(
                        model,
                        style: AppTypography.technicalMono(
                          t.textSecondary,
                          fontSize: 9.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType? keyboardType,
    ValueChanged<String>? onSubmitted,
    Widget? suffix,
  }) {
    final t = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.technicalMono(
            t.textMuted,
            fontSize: 8.5,
            weight: FontWeight.w700,
          ).copyWith(letterSpacing: 1.0),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          onSubmitted: onSubmitted,
          style: AppTypography.technicalMono(t.textPrimary, fontSize: 11.5),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: AppTypography.technicalMono(t.textMuted, fontSize: 11),
            filled: true,
            fillColor: t.surfaceHigh,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 11,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: t.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: t.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: t.accent),
            ),
          ),
        ),
      ],
    );
  }
}
