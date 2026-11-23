import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_tokens.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/haptics.dart';
import '../../core/widgets/ai_mark.dart';
import '../../core/widgets/app_icon_button.dart';
import '../../core/widgets/metric_tile.dart';
import '../../core/widgets/scientific_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/analysis_run.dart';
import '../../shared/models/session.dart';
import '../../shared/services/session_repository.dart';
import '../../shared/services/storage_service.dart';
import '../settings/settings_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionRepositoryProvider);
    final storage = ref.watch(storageServiceProvider);
    final t = context.tokens;

    final totalFields = sessions.fold<int>(
      0,
      (sum, s) => sum + s.images.length,
    );
    final pendingReviews = sessions.fold<int>(
      0,
      (sum, s) =>
          sum +
          s.images
              .where(
                (img) => img.analysisRun?.reviewStatus == ReviewStatus.pending,
              )
              .length,
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(
                20,
                58,
                20,
                110 + MediaQuery.viewPaddingOf(context).bottom,
              ),
              children: [
                _HeroPanel(
                  onStart: () {
                    Haptics.tap();
                    context.push('/new-session');
                  },
                ),
                const SizedBox(height: 24),
                const SectionHeader(title: 'Workstation telemetry'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: MetricTile(
                        label: 'Sessions',
                        value: '${sessions.length}',
                        subtitle: 'Logged offline',
                        icon: Icons.folder_open_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MetricTile(
                        label: 'Fields',
                        value: '$totalFields',
                        subtitle: 'Captured images',
                        icon: Icons.filter_center_focus_rounded,
                        accentColor: t.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: MetricTile(
                        label: 'Pending',
                        value: '$pendingReviews',
                        subtitle: 'Awaiting sign-off',
                        icon: Icons.rate_review_outlined,
                        accentColor: pendingReviews > 0 ? t.warning : t.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MetricTile(
                        label: 'Storage',
                        value: Formatters.formatBytes(storage.totalBytes),
                        subtitle: 'Images & models',
                        icon: Icons.sd_storage_outlined,
                        onTap: () => showSettingsSheet(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                const _CopilotCard(),
                const SizedBox(height: 26),
                SectionHeader(
                  title: 'Recent sessions',
                  actionLabel: 'View all',
                  onAction: () => context.push('/sessions'),
                ),
                const SizedBox(height: 12),
                if (sessions.isEmpty)
                  ScientificCard(
                    child: Column(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: t.accentSoft,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.biotech_outlined,
                            size: 24,
                            color: t.accent,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'No sessions yet',
                          style: AppTypography.title(t.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Capture your first calibrated field to populate the workstation.',
                          textAlign: TextAlign.center,
                          style: AppTypography.caption(t.textMuted),
                        ),
                      ],
                    ),
                  )
                else
                  for (final session in sessions.take(3))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _SessionRow(
                        session: session,
                        onTap: () => context.push('/session/${session.id}'),
                      ),
                    ),
                const SizedBox(height: 18),
                SectionHeader(
                  title: 'Analysis module',
                  actionLabel: 'Catalog',
                  onAction: () => context.push('/modules'),
                ),
                const SizedBox(height: 12),
                const _ModuleCard(),
                const SizedBox(height: 20),
                const _DisclaimerNote(),
              ],
            ),
            Positioned(
              top: 8,
              right: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIconButton(
                    tooltip: 'Local AI copilot',
                    onPressed: () => context.push('/assistant'),
                    child: const AiMark(size: 21, glow: true),
                  ),
                  const SizedBox(width: 8),
                  AppIconButton(
                    icon: Icons.tune_rounded,
                    tooltip: 'Workstation settings',
                    onPressed: () => showSettingsSheet(context),
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

// ─────────────────────────────────────────────────────────────────────────────

class _HeroPanel extends StatelessWidget {
  final VoidCallback onStart;

  const _HeroPanel({required this.onStart});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final titleColor = t.textPrimary;
    final bodyColor = t.textSecondary;
    final metaColor = t.textMuted;

    return Container(
      decoration: BoxDecoration(
        color: t.heroSurface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: t.accent.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: t.accent.withValues(alpha: t.isDark ? 0.07 : 0.10),
            blurRadius: 34,
            spreadRadius: -16,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            Positioned(
              right: -70,
              top: -80,
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: t.accent.withValues(alpha: 0.14),
                    width: 1,
                  ),
                ),
              ),
            ),
            Positioned(
              right: -20,
              top: -30,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: t.accent.withValues(alpha: 0.16),
                    width: 1,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 24,
              top: 24,
              child: Icon(
                Icons.adjust_rounded,
                size: 74,
                color: t.accent.withValues(alpha: 0.12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const StatusBadge(
                        label: 'Adapter ready',
                        type: BadgeType.pass,
                        isCompact: true,
                      ),
                      const Spacer(),
                      Text(
                        '40× · BF',
                        style: AppTypography.technicalMono(
                          metaColor,
                          fontSize: 9.5,
                        ).copyWith(letterSpacing: 1.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'Start a microscopy\nsession',
                    style: AppTypography.display(titleColor)
                        .copyWith(fontSize: 27, height: 1.12),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Mount the adapter, configure slide metadata and acquire calibrated fields.',
                    style: AppTypography.body(bodyColor).copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onStart,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('New session'),
                        ],
                      ),
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

class _CopilotCard extends StatelessWidget {
  const _CopilotCard();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return ScientificCard(
      glow: true,
      borderColor: t.accent.withValues(alpha: 0.24),
      onTap: () => context.push('/assistant'),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: t.accentSoft,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: t.accent.withValues(alpha: 0.24)),
            ),
            child: const Center(child: AiMark(size: 23, glow: true)),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 7,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Local AI copilot',
                      style: AppTypography.title(t.textPrimary)
                          .copyWith(fontSize: 15),
                    ),
                    const StatusBadge(
                      label: 'On-device',
                      type: BadgeType.humanObservation,
                      isCompact: true,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Ask your phone’s model about any session, field or result. Nothing leaves the device.',
                  style: AppTypography.caption(t.textMuted)
                      .copyWith(fontSize: 11.5, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, size: 18, color: t.accent),
        ],
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  final MicroscopySession session;
  final VoidCallback onTap;

  const _SessionRow({required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final preview = session.images.isNotEmpty
        ? session.images.first.assetPath
        : null;

    return ScientificCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 52,
              height: 52,
              child: preview != null
                  ? Image.asset(
                      preview,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _thumbFallback(t),
                    )
                  : _thumbFallback(t),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      session.specimenCode,
                      style: AppTypography.technicalMono(
                        t.accent,
                        fontSize: 10.5,
                        weight: FontWeight.w700,
                      ).copyWith(letterSpacing: 0.6),
                    ),
                    StatusBadge(
                      label: session.status.displayName,
                      type: session.status == SessionStatus.reviewed
                          ? BadgeType.pass
                          : (session.status == SessionStatus.completed
                                ? BadgeType.humanObservation
                                : BadgeType.warning),
                      isCompact: true,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  session.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.title(t.textPrimary)
                      .copyWith(fontSize: 14.5),
                ),
                const SizedBox(height: 3),
                Text(
                  '${session.specimenType} · ${session.images.length} fields · ${Formatters.formatShortDate(session.createdAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption(t.textMuted)
                      .copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.chevron_right_rounded, size: 20, color: t.textMuted),
        ],
      ),
    );
  }

  Widget _thumbFallback(AppTokens t) {
    return Container(
      color: t.surfaceHigh,
      child: Icon(Icons.biotech_outlined, size: 22, color: t.textMuted),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return ScientificCard(
      glow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: t.accentSoft,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: t.accent.withValues(alpha: 0.18)),
                ),
                child: Icon(Icons.spa_outlined, color: t.accent, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Mycology Patch Classifier',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.title(t.textPrimary)
                                .copyWith(fontSize: 15),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const StatusBadge(
                          label: 'Ready',
                          type: BadgeType.pass,
                          isCompact: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'DeFungi 5-class morphology · MobileNetV3-Small · Float16',
                      maxLines: 2,
                      style: AppTypography.caption(t.textMuted)
                          .copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: 0.72,
                    minHeight: 5,
                    backgroundColor: t.surfaceHigh,
                    valueColor: AlwaysStoppedAnimation(t.accent),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '72%',
                style: AppTypography.technicalMono(
                  t.textMuted,
                  fontSize: 10,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 13, color: t.textMuted),
              const SizedBox(width: 5),
              Text(
                'Median inference 480 ms · on-device',
                style: AppTypography.caption(t.textMuted)
                    .copyWith(fontSize: 11),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Haptics.tap();
                  context.push('/models');
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Manage'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DisclaimerNote extends StatelessWidget {
  const _DisclaimerNote();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.surface.withValues(alpha: t.isDark ? 0.5 : 1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_outlined, size: 16, color: t.textMuted),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Decision-support only. Model outputs require human microscopist verification '
              'and are never transmitted off-device.',
              style: AppTypography.caption(t.textMuted)
                  .copyWith(fontSize: 11, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
