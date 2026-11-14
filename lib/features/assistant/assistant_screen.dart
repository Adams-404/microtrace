import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_tokens.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/haptics.dart';
import '../../core/widgets/ai_mark.dart';
import '../../shared/models/assistant_message.dart';
import '../../shared/models/session.dart';
import '../../shared/services/local_ai_service.dart';
import '../../shared/services/session_repository.dart';
import '../settings/settings_screen.dart';
import 'assistant_controller.dart';
import 'session_context.dart';

/// On-device copilot chat. Optionally grounded on one microscopy session via
/// `/assistant?session=<id>`.
class AssistantScreen extends ConsumerStatefulWidget {
  final String? sessionId;

  const AssistantScreen({super.key, this.sessionId});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final TextEditingController _composer = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final FocusNode _focus = FocusNode();

  MicroscopySession? _session;
  String? _context;
  String? _contextLabel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resolveSession();
      ref.read(assistantChatProvider.notifier).checkServer();
    });
  }

  void _resolveSession() {
    final id = widget.sessionId;
    if (id == null) return;
    final sessions = ref.read(sessionRepositoryProvider);
    for (final session in sessions) {
      if (session.id == id) {
        setState(() {
          _session = session;
          _context = buildSessionContext(session);
          _contextLabel = 'Grounded · ${session.specimenCode}';
        });
        return;
      }
    }
  }

  @override
  void dispose() {
    _composer.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scroll.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _send([String? preset]) {
    final text = preset ?? _composer.text;
    if (text.trim().isEmpty) return;
    if (!ref.read(assistantChatProvider).isStreaming) {
      Haptics.tap();
    }
    if (preset == null) _composer.clear();
    _focus.unfocus();
    ref
        .read(assistantChatProvider.notifier)
        .send(text, context: _context, contextLabel: _contextLabel);
    _scrollToBottom();
  }

  void _clearChat() {
    Haptics.select();
    ref.read(assistantChatProvider.notifier).clear();
    ref.read(assistantChatProvider.notifier).checkServer();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assistantChatProvider);
    final settings = ref.watch(assistantSettingsProvider);

    ref.listen(assistantChatProvider, (previous, next) {
      if (previous == next) return;
      _scrollToBottom();
    });

    final modelLabel = state.status.model ?? settings.model;
    final hasMessages = state.messages.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _AssistantHeader(
              canClear: hasMessages,
              onClear: _clearChat,
              onSettings: () => showSettingsSheet(context),
              onBack: () {
                Haptics.tap();
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
            ),
            if (_session != null)
              _ContextChip(
                session: _session!,
                onOpen: () {
                  Haptics.tap();
                  context.push('/session/${_session!.id}');
                },
              ),
            Expanded(
              child: hasMessages
                  ? _MessageList(
                      state: state,
                      scroll: _scroll,
                      modelLabel: modelLabel.isEmpty
                          ? 'Local model'
                          : modelLabel,
                    )
                  : _EmptyState(
                      status: state.status,
                      session: _session,
                      onSuggest: _send,
                      onRetry: () => ref
                          .read(assistantChatProvider.notifier)
                          .checkServer(),
                    ),
            ),
            _Composer(
              controller: _composer,
              focusNode: _focus,
              isStreaming: state.isStreaming,
              hasText: _composer.text.trim().isNotEmpty,
              onSend: _send,
              onStop: () => ref.read(assistantChatProvider.notifier).stop(),
              onChanged: () => setState(() {}),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _AssistantHeader extends StatelessWidget {
  final bool canClear;
  final VoidCallback onClear;
  final VoidCallback onSettings;
  final VoidCallback onBack;

  const _AssistantHeader({
    required this.canClear,
    required this.onClear,
    required this.onSettings,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        children: [
          _CircleAction(
            icon: Icons.arrow_back_rounded,
            onPressed: onBack,
            tooltip: 'Back',
          ),
          const Spacer(),
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: t.surface,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: t.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PillAction(
                  icon: Icons.restart_alt_rounded,
                  tooltip: 'New conversation',
                  onPressed: canClear ? onClear : null,
                ),
                Container(width: 1, height: 18, color: t.border),
                _PillAction(
                  icon: Icons.tune_rounded,
                  tooltip: 'Local AI settings',
                  onPressed: onSettings,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContextChip extends StatelessWidget {
  final MicroscopySession session;
  final VoidCallback onOpen;

  const _ContextChip({required this.session, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(99),
          onTap: onOpen,
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: t.accentSoft,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: t.accent.withValues(alpha: 0.24)),
            ),
            child: Row(
              children: [
                Icon(Icons.link_rounded, size: 14, color: t.accent),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Grounded on ${session.specimenCode} · ${session.images.length} fields',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption(t.textPrimary)
                        .copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 5),
                Icon(Icons.open_in_new_rounded, size: 12, color: t.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final AiStatus status;
  final MicroscopySession? session;
  final void Function(String) onSuggest;
  final VoidCallback onRetry;

  const _EmptyState({
    required this.status,
    required this.session,
    required this.onSuggest,
    required this.onRetry,
  });

  List<(IconData, String)> get _suggestions {
    if (session != null) {
      return [
        (
          Icons.fact_check_outlined,
          'Summarise this session and flag what needs review',
        ),
        (
          Icons.filter_center_focus_rounded,
          'Which fields failed quality control?',
        ),
        (
          Icons.biotech_outlined,
          'Explain the top prediction and its confidence',
        ),
      ];
    }
    return [
      (Icons.science_outlined, 'What can this workstation help me with?'),
      (Icons.center_focus_strong_outlined, 'How do I improve field sharpness?'),
      (Icons.insights_outlined, 'Explain how confidence scores are computed'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - 20).clamp(0.0, 99999.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.alphaBlend(
                        t.accent.withValues(alpha: 0.10),
                        t.surface,
                      ),
                      border: Border.all(
                        color: t.accent.withValues(alpha: 0.22),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: t.accent.withValues(alpha: 0.16),
                          blurRadius: 52,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: const Center(child: AiMark(size: 44, glow: true)),
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  'Hi there,',
                  textAlign: TextAlign.center,
                  style: AppTypography.display(t.textSecondary).copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    letterSpacing: -0.9,
                  ),
                ),
                Text(
                  session == null
                      ? 'What should we look at?'
                      : 'What should we review?',
                  textAlign: TextAlign.center,
                  style: AppTypography.display(t.textPrimary).copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    height: 1.18,
                    letterSpacing: -0.9,
                  ),
                ),
                const SizedBox(height: 30),
                for (final (icon, label) in _suggestions)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _SuggestionTile(
                      icon: icon,
                      label: label,
                      onTap: () => onSuggest(label),
                    ),
                  ),
                const SizedBox(height: 14),
                _StatusLine(status: status, onRetry: onRetry),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SuggestionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: () {
          Haptics.tap();
          onTap();
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: t.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: t.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 21, color: t.textSecondary),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.body(t.textPrimary)
                      .copyWith(fontSize: 14, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  final AiStatus status;
  final VoidCallback onRetry;

  const _StatusLine({required this.status, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    final (color, label) = switch (status.health) {
      AiHealth.online => (t.success, status.model ?? 'Local model ready'),
      AiHealth.checking => (t.warning, 'Connecting to local model…'),
      AiHealth.offline => (t.danger, status.message ?? 'Local model offline'),
      AiHealth.unknown => (t.textMuted, 'Local model standby'),
    };

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (status.health == AiHealth.checking)
              SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 1.6,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              )
            else
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.technicalMono(
                  color,
                  fontSize: 9.5,
                  weight: FontWeight.w600,
                ),
              ),
            ),
            if (!status.isOnline && status.health != AiHealth.checking) ...[
              const SizedBox(width: 4),
              TextButton(
                onPressed: () {
                  Haptics.tap();
                  onRetry();
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 26),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
        if (!status.isOnline && status.hint != null) ...[
          const SizedBox(height: 5),
          Text(
            status.hint!,
            textAlign: TextAlign.center,
            style: AppTypography.technicalMono(
              t.textMuted,
              fontSize: 9.5,
            ).copyWith(height: 1.45),
          ),
        ],
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline_rounded, size: 10, color: t.textMuted),
            const SizedBox(width: 4),
            Text(
              'On-device · nothing leaves this phone',
              style: AppTypography.caption(t.textMuted).copyWith(fontSize: 9.5),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _MessageList extends StatelessWidget {
  final AssistantState state;
  final ScrollController scroll;
  final String? modelLabel;

  const _MessageList({
    required this.state,
    required this.scroll,
    required this.modelLabel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scroll,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      itemCount: state.messages.length + (state.isStreaming ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.messages.length) {
          return const _ThinkingBubble();
        }
        final message = state.messages[index];
        final isUser = message.role == AssistantRole.user;
        final isLast = index == state.messages.length - 1;
        if (!isUser && message.content.isEmpty && isLast) {
          return const SizedBox.shrink();
        }
        return _MessageBubble(
          message: message,
          modelLabel: modelLabel,
          isStreaming: state.isStreaming && isLast && !isUser,
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final AssistantMessage message;
  final String? modelLabel;
  final bool isStreaming;

  const _MessageBubble({
    required this.message,
    required this.isStreaming,
    this.modelLabel,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final isUser = message.role == AssistantRole.user;

    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14, left: 48),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: t.accentSoft,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(6),
            ),
            border: Border.all(color: t.accent.withValues(alpha: 0.26)),
          ),
          child: Text(
            message.content,
            style: AppTypography.body(t.textPrimary)
                .copyWith(fontSize: 13.5, height: 1.5),
          ),
        ),
      );
    }

    final error = message.isError;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14, right: 26),
        padding: const EdgeInsets.fromLTRB(15, 12, 15, 14),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(
            color: error ? t.danger.withValues(alpha: 0.45) : t.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AiMark(size: 12, color: error ? t.danger : t.accent),
                const SizedBox(width: 6),
                Text(
                  error ? 'LOCAL MODEL · ERROR' : 'LOCAL MODEL',
                  style: AppTypography.technicalMono(
                    error ? t.danger : t.textMuted,
                    fontSize: 8.5,
                    weight: FontWeight.w700,
                  ).copyWith(letterSpacing: 1.0),
                ),
                if (modelLabel != null && modelLabel!.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      modelLabel!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption(t.textMuted)
                          .copyWith(fontSize: 9.5),
                    ),
                  ),
                ] else
                  const Spacer(),
              ],
            ),
            const SizedBox(height: 9),
            _ReplyBody(text: message.content, streaming: isStreaming),
          ],
        ),
      ),
    );
  }
}

class _ReplyBody extends StatelessWidget {
  final String text;
  final bool streaming;

  const _ReplyBody({required this.text, required this.streaming});

  static String _clean(String value) {
    return value
        .replaceAll('**', '')
        .replaceAll('__', '')
        .replaceAll('`', '')
        .replaceAll('###', '');
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final lines = text.split('\n');
    final children = <Widget>[];

    for (final raw in lines) {
      final line = _clean(raw);
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        children.add(const SizedBox(height: 7));
        continue;
      }

      final bullet = RegExp(r'^[-*•]\s+').firstMatch(trimmed);
      final numbered = RegExp(r'^(\d+)\.\s+').firstMatch(trimmed);

      if (bullet != null) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 4.5,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: t.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    trimmed.substring(bullet.end),
                    style: AppTypography.body(t.textPrimary)
                        .copyWith(fontSize: 13.5, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (numbered != null) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 18,
                  child: Text(
                    '${numbered.group(1)}.',
                    style: AppTypography.technicalMono(
                      t.accent,
                      fontSize: 11,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    trimmed.substring(numbered.end),
                    style: AppTypography.body(t.textPrimary)
                        .copyWith(fontSize: 13.5, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              trimmed,
              style: AppTypography.body(t.textPrimary)
                  .copyWith(fontSize: 13.5, height: 1.55),
            ),
          ),
        );
      }
    }

    if (streaming) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: _Cursor(color: t.accent),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _Cursor extends StatefulWidget {
  final Color color;
  const _Cursor({required this.color});

  @override
  State<_Cursor> createState() => _CursorState();
}

class _CursorState extends State<_Cursor> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 7,
        height: 14,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: t.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AiMark(size: 16, color: t.accent),
            const SizedBox(width: 9),
            Text(
              'The colony is thinking…',
              style: AppTypography.caption(t.textMuted)
                  .copyWith(fontSize: 11.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isStreaming;
  final bool hasText;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final VoidCallback onChanged;

  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.isStreaming,
    required this.hasText,
    required this.onSend,
    required this.onStop,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final canSend = hasText && !isStreaming;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -40,
          right: -40,
          bottom: 0,
          height: 250,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 1.05),
                  radius: 1.0,
                  colors: [
                    t.accent.withValues(alpha: t.isDark ? 0.17 : 0.22),
                    t.accent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            14,
            4,
            14,
            keyboard > 0 ? 10 : 12 + MediaQuery.paddingOf(context).bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 7, 7, 7),
            decoration: BoxDecoration(
              color: t.surfaceHigh,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: t.accent.withValues(alpha: 0.22)),
              boxShadow: [
                BoxShadow(
                  color: t.accent.withValues(alpha: t.isDark ? 0.22 : 0.26),
                  blurRadius: 56,
                  spreadRadius: 6,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: t.accent.withValues(alpha: t.isDark ? 0.10 : 0.14),
                  blurRadius: 110,
                  spreadRadius: 34,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AiMark(size: 19, color: t.textMuted),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    onChanged: (_) => onChanged(),
                    onSubmitted: (_) {
                      if (canSend) onSend();
                    },
                    style: AppTypography.body(t.textPrimary)
                        .copyWith(fontSize: 14, height: 1.45),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: isStreaming ? 'Generating…' : 'Ask anything',
                      hintStyle: AppTypography.body(t.textMuted)
                          .copyWith(fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (isStreaming)
                  _SendButton(
                    icon: Icons.stop_rounded,
                    enabled: true,
                    onTap: onStop,
                    enabledColor: t.danger,
                  )
                else
                  _SendButton(
                    icon: Icons.arrow_upward_rounded,
                    enabled: canSend,
                    onTap: onSend,
                    enabledColor: t.accent,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SendButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final Color enabledColor;

  const _SendButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.enabledColor,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return SizedBox(
      width: 44,
      height: 44,
      child: Material(
        color: enabled ? enabledColor : t.surface,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled
              ? () {
                  Haptics.tap();
                  onTap();
                }
              : null,
          child: Icon(
            icon,
            size: 20,
            color: enabled ? t.onAccent : t.textMuted,
          ),
        ),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  const _CircleAction({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 46,
        height: 46,
        child: Material(
          color: t.surface,
          shape: CircleBorder(side: BorderSide(color: t.border)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Haptics.tap();
              onPressed();
            },
            child: Icon(icon, size: 20, color: t.textPrimary),
          ),
        ),
      ),
    );
  }
}

class _PillAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const _PillAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(23),
        onTap: onPressed == null
            ? null
            : () {
                Haptics.tap();
                onPressed!();
              },
        child: SizedBox(
          width: 52,
          height: 46,
          child: Icon(
            icon,
            size: 20,
            color: onPressed == null
                ? t.textMuted.withValues(alpha: 0.4)
                : t.textSecondary,
          ),
        ),
      ),
    );
  }
}
