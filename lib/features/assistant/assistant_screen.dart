import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_tokens.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/haptics.dart';
import '../../shared/models/assistant_message.dart';
import '../../shared/models/session.dart';
import '../../shared/services/local_ai_service.dart';
import '../../shared/services/session_repository.dart';
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
            _Header(
              status: state.status,
              modelLabel: modelLabel.isEmpty ? 'Local model' : modelLabel,
              onClear: hasMessages ? _clearChat : null,
              onSettings: () {
                Haptics.tap();
                context.push('/settings');
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
                      modelLabel: modelLabel,
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

class _Header extends StatelessWidget {
  final AiStatus status;
  final String modelLabel;
  final VoidCallback? onClear;
  final VoidCallback onSettings;

  const _Header({
    required this.status,
    required this.modelLabel,
    required this.onClear,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final (color, label) = switch (status.health) {
      AiHealth.online => (t.success, 'Online'),
      AiHealth.checking => (t.warning, 'Checking'),
      AiHealth.offline => (t.danger, 'Offline'),
      AiHealth.unknown => (t.textMuted, 'Standby'),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Row(
        children: [
          _IconAction(
            icon: Icons.arrow_back_rounded,
            onPressed: () {
              Haptics.tap();
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'LOCAL AI · ${label.toUpperCase()}',
                      style: AppTypography.technicalMono(
                        color,
                        fontSize: 9,
                        weight: FontWeight.w700,
                      ).copyWith(letterSpacing: 1.1),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Assistant',
                  style: AppTypography.title(t.textPrimary)
                      .copyWith(fontSize: 19, letterSpacing: -0.4),
                ),
                Text(
                  modelLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption(t.textMuted)
                      .copyWith(fontSize: 10.5),
                ),
              ],
            ),
          ),
          if (onClear != null)
            _IconAction(icon: Icons.restart_alt_rounded, onPressed: onClear!),
          const SizedBox(width: 6),
          _IconAction(icon: Icons.tune_rounded, onPressed: onSettings),
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
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onOpen,
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: t.accentSoft,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: t.accent.withValues(alpha: 0.26)),
            ),
            child: Row(
              children: [
                Icon(Icons.link_rounded, size: 15, color: t.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Grounded on ${session.specimenCode} · ${session.images.length} fields',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption(t.textPrimary)
                        .copyWith(fontSize: 11.5, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.open_in_new_rounded, size: 13, color: t.accent),
              ],
            ),
          ),
        ),
      ),
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
          margin: const EdgeInsets.only(bottom: 14, left: 42),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: t.accentSoft,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(5),
            ),
            border: Border.all(color: t.accent.withValues(alpha: 0.28)),
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
        margin: const EdgeInsets.only(bottom: 14, right: 24),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 13),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(16),
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
                Icon(
                  error ? Icons.error_outline_rounded : Icons.blur_on_rounded,
                  size: 13,
                  color: error ? t.danger : t.accent,
                ),
                const SizedBox(width: 5),
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
            const SizedBox(height: 8),
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: t.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.8,
                valueColor: AlwaysStoppedAnimation(t.accent),
              ),
            ),
            const SizedBox(width: 9),
            Text(
              'Model is thinking…',
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

  List<String> get _suggestions {
    if (session != null) {
      return [
        'Summarise this session and flag what needs review.',
        'Which fields failed quality control or need recapture?',
        'Explain the top prediction and its confidence.',
        'Draft reviewer notes for the pending field.',
      ];
    }
    return [
      'What can you help me with?',
      'How do I improve field sharpness?',
      'Explain how confidence scores are computed.',
      'Give me a checklist for a clean capture run.',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final online = status.isOnline;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: t.accentSoft,
              shape: BoxShape.circle,
              border: Border.all(color: t.accent.withValues(alpha: 0.3)),
            ),
            child: Icon(Icons.auto_awesome_outlined, size: 30, color: t.accent),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          session == null ? 'Ask your local model' : 'Ask about this session',
          textAlign: TextAlign.center,
          style: AppTypography.headline(t.textPrimary)
              .copyWith(fontSize: 21, letterSpacing: -0.5),
        ),
        const SizedBox(height: 8),
        Text(
          session == null
              ? 'Runs entirely on your phone through llama.cpp. No cloud, no uploads — '
                    'your session data never leaves the device.'
              : 'This conversation is grounded on ${session!.specimenCode}. '
                    'The model only sees the facts shown in the app.',
          textAlign: TextAlign.center,
          style: AppTypography.caption(t.textMuted)
              .copyWith(fontSize: 12, height: 1.55),
        ),
        const SizedBox(height: 20),
        _ConnectionCard(status: status, onRetry: onRetry),
        const SizedBox(height: 20),
        if (online) ...[
          Text(
            'TRY ASKING',
            style: AppTypography.label(t.textMuted).copyWith(fontSize: 9.5),
          ),
          const SizedBox(height: 10),
          for (final suggestion in _suggestions)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _SuggestionTile(
                label: suggestion,
                onTap: () => onSuggest(suggestion),
              ),
            ),
        ],
      ],
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  final AiStatus status;
  final VoidCallback onRetry;

  const _ConnectionCard({required this.status, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final (color, title, icon) = switch (status.health) {
      AiHealth.online => (
        t.success,
        'Local model ready',
        Icons.check_circle_outline_rounded,
      ),
      AiHealth.checking => (
        t.warning,
        'Contacting local model…',
        Icons.sync_rounded,
      ),
      AiHealth.offline => (
        t.danger,
        'Local model offline',
        Icons.cloud_off_rounded,
      ),
      AiHealth.unknown => (
        t.textMuted,
        'Local model standby',
        Icons.bolt_outlined,
      ),
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.bodyMedium(t.textPrimary)
                      .copyWith(fontSize: 13),
                ),
              ),
              if (status.health != AiHealth.checking)
                TextButton(
                  onPressed: () {
                    Haptics.tap();
                    onRetry();
                  },
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, 28),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Retry'),
                ),
            ],
          ),
          if (status.message != null) ...[
            const SizedBox(height: 5),
            Text(
              status.message!,
              style: AppTypography.caption(t.textSecondary)
                  .copyWith(fontSize: 11.5, height: 1.45),
            ),
          ],
          if (status.hint != null) ...[
            const SizedBox(height: 5),
            Text(
              status.hint!,
              style: AppTypography.technicalMono(
                t.textMuted,
                fontSize: 10,
              ).copyWith(height: 1.45),
            ),
          ],
          if (status.isOnline && status.model != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.memory_rounded, size: 12, color: t.textMuted),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    status.model!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.technicalMono(
                      t.textMuted,
                      fontSize: 10,
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
}

class _SuggestionTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SuggestionTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () {
          Haptics.tap();
          onTap();
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          decoration: BoxDecoration(
            color: t.surface,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: t.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.caption(t.textSecondary)
                      .copyWith(fontSize: 12.5),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.north_east_rounded, size: 14, color: t.accent),
            ],
          ),
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

    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        4,
        12,
        MediaQuery.viewInsetsOf(context).bottom > 0
            ? 10
            : 8 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
        decoration: BoxDecoration(
          color: t.surfaceHigh,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: t.borderStrong),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
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
                      .copyWith(fontSize: 13.5, height: 1.45),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: isStreaming
                        ? 'Generating…'
                        : 'Ask about your sessions…',
                    hintStyle: AppTypography.body(t.textMuted)
                        .copyWith(fontSize: 13.5),
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            if (isStreaming)
              _SendButton(
                icon: Icons.stop_rounded,
                enabled: true,
                onTap: onStop,
                color: t.danger,
              )
            else
              _SendButton(
                icon: Icons.arrow_upward_rounded,
                enabled: canSend,
                onTap: onSend,
                color: t.accent,
              ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final Color color;

  const _SendButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: enabled ? color : t.surface,
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
            size: 19,
            color: enabled ? t.onAccent : t.textMuted,
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _IconAction({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return SizedBox(
      width: 38,
      height: 38,
      child: Material(
        color: t.surfaceHigh.withValues(alpha: t.isDark ? 0.6 : 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
          side: BorderSide(color: t.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Haptics.tap();
            onPressed();
          },
          child: Icon(icon, size: 18, color: t.textSecondary),
        ),
      ),
    );
  }
}
