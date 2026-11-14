import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/haptics.dart';
import '../../shared/models/assistant_message.dart';
import '../../shared/models/assistant_settings.dart';
import '../../shared/services/local_ai_service.dart';

final assistantSettingsProvider =
    NotifierProvider<AssistantSettingsNotifier, AssistantSettings>(
      AssistantSettingsNotifier.new,
    );

class AssistantSettingsNotifier extends Notifier<AssistantSettings> {
  static const _prefKey = 'microtrace_assistant_settings';

  @override
  AssistantSettings build() {
    _load();
    return const AssistantSettings();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefKey);
      if (raw != null && raw.isNotEmpty) {
        state = AssistantSettings.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      }
    } catch (_) {
      // Keep defaults.
    }
  }

  Future<void> update(AssistantSettings settings) async {
    state = settings;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, jsonEncode(settings.toJson()));
    } catch (_) {
      // Preference persistence is best-effort.
    }
  }
}

class AssistantState {
  final List<AssistantMessage> messages;
  final bool isStreaming;
  final String? error;
  final AiStatus status;
  final String? contextLabel;

  const AssistantState({
    this.messages = const [],
    this.isStreaming = false,
    this.error,
    this.status = const AiStatus(),
    this.contextLabel,
  });

  AssistantState copyWith({
    List<AssistantMessage>? messages,
    bool? isStreaming,
    String? error,
    bool clearError = false,
    AiStatus? status,
    String? contextLabel,
  }) {
    return AssistantState(
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
      error: clearError ? null : (error ?? this.error),
      status: status ?? this.status,
      contextLabel: contextLabel ?? this.contextLabel,
    );
  }
}

final assistantChatProvider =
    NotifierProvider<AssistantChatController, AssistantState>(
      AssistantChatController.new,
    );

class AssistantChatController extends Notifier<AssistantState> {
  static const _baseInstructions = '''
You are MICROTRACE Assistant, an on-device microscopy copilot inside a field microscopy workstation.
Rules:
- Answer from the supplied session context when it is provided. If the context does not contain the answer, say what is missing instead of inventing it.
- Be concise: at most 180 words unless the user asks for a checklist or report.
- Use precise laboratory language. Refer to fields by number.
- You are decision support only. Never give a definitive diagnosis and always remind the user that a qualified microscopist must verify findings.
- No markdown tables. Short paragraphs and bullet lists are fine.
''';

  AiCancelToken? _token;

  @override
  AssistantState build() => const AssistantState();

  Future<void> checkServer() async {
    if (state.status.health == AiHealth.checking) return;
    state = state.copyWith(
      status: const AiStatus(health: AiHealth.checking),
      clearError: true,
    );
    final settings = ref.read(assistantSettingsProvider);
    final status = await LocalAiService(settings).checkStatus();
    state = state.copyWith(status: status);
  }

  void clear() {
    _token?.cancel();
    state = const AssistantState();
  }

  void stop() {
    _token?.cancel();
    state = state.copyWith(isStreaming: false);
  }

  Future<void> send(
    String text, {
    String? context,
    String? contextLabel,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isStreaming) return;

    Haptics.tap();

    final history = <AssistantMessage>[...state.messages];
    const reply = AssistantMessage(role: AssistantRole.assistant, content: '');
    state = state.copyWith(
      messages: [
        ...history,
        AssistantMessage(role: AssistantRole.user, content: trimmed),
        reply,
      ],
      isStreaming: true,
      clearError: true,
      contextLabel: contextLabel,
    );

    final settings = ref.read(assistantSettingsProvider);
    final token = AiCancelToken();
    _token = token;

    final systemPrompt = context == null || context.trim().isEmpty
        ? _baseInstructions
        : '$_baseInstructions\nSESSION CONTEXT (verified app data):\n${context.trim()}';

    try {
      await LocalAiService(settings).streamChat(
        messages: history,
        systemPrompt: systemPrompt,
        token: token,
        onDelta: (delta) {
          final messages = List<AssistantMessage>.from(state.messages);
          if (messages.isEmpty) return;
          final last = messages.last;
          messages[messages.length - 1] = last.copyWith(
            content: '${last.content}$delta',
          );
          state = state.copyWith(messages: messages);
        },
      );

      final messages = List<AssistantMessage>.from(state.messages);
      if (messages.isNotEmpty && messages.last.content.trim().isEmpty) {
        messages[messages.length - 1] = messages.last.copyWith(
          content: 'The model returned an empty response. Try a shorter question or restart the local server.',
        );
        state = state.copyWith(messages: messages);
      }
      Haptics.success();
    } on LocalAiException catch (e) {
      _fail(e.message);
    } catch (e) {
      _fail('$e');
    } finally {
      _token = null;
      if (!token.cancelled || state.isStreaming) {
        state = state.copyWith(isStreaming: false);
      }
    }
  }

  void _fail(String message) {
    Haptics.warning();
    final messages = List<AssistantMessage>.from(state.messages);
    if (messages.isNotEmpty && messages.last.role == AssistantRole.assistant) {
      messages[messages.length - 1] = messages.last.copyWith(
        content: messages.last.content.trim().isEmpty
            ? 'I could not reach the local model.\n\n$message'
            : messages.last.content,
        isError: true,
      );
    }
    state = state.copyWith(
      messages: messages,
      isStreaming: false,
      error: message,
      status: AiStatus(
        health: AiHealth.offline,
        message: state.status.message,
        hint: 'Start the model with `clearport start` in Termux, then retry.',
      ),
    );
  }
}
