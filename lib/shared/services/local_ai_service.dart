import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/assistant_message.dart';
import '../models/assistant_settings.dart';
import 'stream_parser.dart';

enum AiHealth { unknown, checking, online, offline }

class AiStatus {
  final AiHealth health;
  final String? model;
  final List<String> models;
  final String? message;
  final String? hint;

  const AiStatus({
    this.health = AiHealth.unknown,
    this.model,
    this.models = const [],
    this.message,
    this.hint,
  });

  bool get isOnline => health == AiHealth.online;

  AiStatus copyWith({
    AiHealth? health,
    String? model,
    List<String>? models,
    String? message,
    String? hint,
  }) {
    return AiStatus(
      health: health ?? this.health,
      model: model ?? this.model,
      models: models ?? this.models,
      message: message ?? this.message,
      hint: hint ?? this.hint,
    );
  }
}

class AiCancelToken {
  bool cancelled = false;
  void Function()? _onCancel;

  void cancel() {
    if (cancelled) return;
    cancelled = true;
    _onCancel?.call();
  }

  void _bind(void Function() callback) {
    _onCancel = callback;
    if (cancelled) callback();
  }
}

class LocalAiException implements Exception {
  final String message;
  const LocalAiException(this.message);

  @override
  String toString() => message;
}

/// Minimal OpenAI-compatible client for an on-device llama.cpp / Clearport
/// server. No cloud, no telemetry — the base URL defaults to loopback.
class LocalAiService {
  final AssistantSettings settings;

  LocalAiService(this.settings);

  String get _base => AssistantSettings.normalizeBaseUrl(settings.baseUrl);

  Uri get chatUri => Uri.parse('$_base/chat/completions');
  Uri get modelsUri => Uri.parse('$_base/models');

  Future<AiStatus> checkStatus({
    Duration timeout = const Duration(seconds: 4),
  }) async {
    final client = http.Client();
    try {
      final request = http.Request('GET', modelsUri)
        ..headers['Accept'] = 'application/json';
      if (settings.apiKey.trim().isNotEmpty) {
        request.headers['Authorization'] = 'Bearer ${settings.apiKey.trim()}';
      }

      final response = await client.send(request).timeout(timeout);
      final body = await response.stream.bytesToString().timeout(timeout);

      if (response.statusCode == 200) {
        final models = _parseModels(body);
        if (models.isEmpty) {
          return const AiStatus(
            health: AiHealth.offline,
            message: 'Server reachable, but no model is loaded.',
            hint: 'Start the model with `clearport start` in Termux.',
          );
        }
        return AiStatus(
          health: AiHealth.online,
          models: models,
          model: settings.model.trim().isNotEmpty
              ? settings.model.trim()
              : models.first,
        );
      }
      if (response.statusCode == 401 || response.statusCode == 403) {
        return const AiStatus(
          health: AiHealth.offline,
          message: 'The local server rejected the API key.',
          hint:
              'Clear the API key in Local AI settings if your server is open.',
        );
      }
      return AiStatus(
        health: AiHealth.offline,
        message: 'Server responded with HTTP ${response.statusCode}.',
        hint: 'Confirm the URL ends in /v1 and points at llama.cpp.',
      );
    } on TimeoutException {
      return AiStatus(
        health: AiHealth.offline,
        message: 'No response within ${timeout.inSeconds}s.',
        hint: 'Run `clearport start` in Termux, then check the port.',
      );
    } on http.ClientException catch (e) {
      return AiStatus(
        health: AiHealth.offline,
        message: 'Could not reach the local model.',
        hint:
            'Start Clearport in Termux, then verify ${modelsUri.host}:${modelsUri.port}. ${e.message}',
      );
    } on FormatException {
      return const AiStatus(
        health: AiHealth.offline,
        message: 'The server returned an unexpected response.',
        hint: 'Check that the URL points at an OpenAI-compatible API.',
      );
    } finally {
      client.close();
    }
  }

  /// Streams a chat completion, calling [onDelta] with each text fragment.
  Future<void> streamChat({
    required List<AssistantMessage> messages,
    required void Function(String delta) onDelta,
    String? systemPrompt,
    AiCancelToken? token,
  }) async {
    if (token?.cancelled ?? false) return;

    final client = http.Client();
    token?._bind(client.close);

    try {
      final request = http.Request('POST', chatUri);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'text/event-stream';
      if (settings.apiKey.trim().isNotEmpty) {
        request.headers['Authorization'] = 'Bearer ${settings.apiKey.trim()}';
      }

      request.body = jsonEncode({
        'stream': true,
        'temperature': settings.temperature,
        if (settings.model.trim().isNotEmpty) 'model': settings.model.trim(),
        'messages': [
          if (systemPrompt != null && systemPrompt.trim().isNotEmpty)
            {'role': 'system', 'content': systemPrompt.trim()},
          for (final message in messages)
            {'role': message.role.wireName, 'content': message.content},
        ],
      });

      if (token?.cancelled ?? false) return;
      final response = await client.send(request);
      if (token?.cancelled ?? false) return;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final body = await response.stream.bytesToString();
        throw LocalAiException(_describeError(response.statusCode, body));
      }

      final mime = response.headers['content-type'] ?? '';
      final parser = StreamParser(rawMode: mime.contains('text/plain'));

      await for (final chunk in response.stream.transform(utf8.decoder)) {
        if (token?.cancelled ?? false) break;
        for (final delta in parser.add(chunk)) {
          onDelta(delta);
        }
        if (parser.done) break;
      }

      if (!(token?.cancelled ?? false) && !parser.done) {
        for (final delta in parser.flush()) {
          onDelta(delta);
        }
      }
      if (parser.errorMessage != null && !(token?.cancelled ?? false)) {
        throw LocalAiException(parser.errorMessage!);
      }
    } on http.ClientException catch (e) {
      if (token?.cancelled ?? false) return;
      throw LocalAiException(
        'Connection lost. Is the local server still running? (${e.message})',
      );
    } on TimeoutException {
      if (token?.cancelled ?? false) return;
      throw const LocalAiException(
        'The model stopped responding. Try a shorter prompt or restart it.',
      );
    } finally {
      client.close();
    }
  }

  List<String> _parseModels(String body) {
    try {
      final decoded = jsonDecode(body);
      final raw = switch (decoded) {
        {'data': final List data} => data,
        {'models': final List models} => models,
        final List list => list,
        _ => const [],
      };
      final names = <String>[];
      for (final entry in raw) {
        if (entry is Map) {
          final id = entry['id'] ?? entry['name'] ?? entry['model'];
          if (id is String && id.trim().isNotEmpty) names.add(id.trim());
        } else if (entry is String && entry.trim().isNotEmpty) {
          names.add(entry.trim());
        }
      }
      return names;
    } catch (_) {
      return const [];
    }
  }

  String _describeError(int status, String body) {
    var detail = body.trim();
    if (detail.startsWith('{')) {
      try {
        final decoded = jsonDecode(detail);
        if (decoded is Map) {
          final error = decoded['error'];
          if (error is String) {
            detail = error;
          } else if (error is Map && error['message'] is String) {
            detail = error['message'] as String;
          } else if (decoded['message'] is String) {
            detail = decoded['message'] as String;
          }
        }
      } catch (_) {
        // Keep raw body.
      }
    }
    if (detail.length > 200) detail = '${detail.substring(0, 200)}…';
    return 'HTTP $status${detail.isEmpty ? '' : ' · $detail'}';
  }
}
