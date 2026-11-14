import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:microtrace/shared/models/assistant_message.dart';
import 'package:microtrace/shared/models/assistant_settings.dart';
import 'package:microtrace/shared/services/local_ai_service.dart';

void main() {
  late HttpServer server;
  late AssistantSettings settings;

  setUp(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    settings = AssistantSettings(baseUrl: 'http://127.0.0.1:${server.port}/v1');

    server.listen((request) async {
      if (request.uri.path.endsWith('/models')) {
        request.response
          ..headers.contentType = ContentType.json
          ..write(
            jsonEncode({
              'data': [
                {'id': 'qwen2.5-1.5b-instruct-q4_k_m.gguf'},
              ],
            }),
          );
        await request.response.close();
        return;
      }

      if (request.uri.path.endsWith('/chat/completions')) {
        request.response.headers.contentType = ContentType(
          'text',
          'event-stream',
          charset: 'utf-8',
        );
        for (final token in ['Aspergillus ', 'niger ', 'confirmed.']) {
          request.response.write(
            'data: ${jsonEncode({
              'choices': [
                {
                  'delta': {'content': token},
                },
              ],
            })}\n\n',
          );
          await request.response.flush();
        }
        request.response.write('data: [DONE]\n\n');
        await request.response.close();
        return;
      }

      request.response.statusCode = 404;
      await request.response.close();
    });
  });

  tearDown(() async {
    await server.close(force: true);
  });

  test('reports an online status with the loaded model', () async {
    final status = await LocalAiService(settings).checkStatus();
    expect(status.isOnline, isTrue);
    expect(status.model, 'qwen2.5-1.5b-instruct-q4_k_m.gguf');
  });

  test('streams chat deltas in order', () async {
    final deltas = <String>[];
    await LocalAiService(settings).streamChat(
      messages: const [
        AssistantMessage(role: AssistantRole.user, content: 'Identify field 1'),
      ],
      systemPrompt: 'Be concise.',
      onDelta: deltas.add,
    );

    expect(deltas.join(), 'Aspergillus niger confirmed.');
  });

  test('reports offline when nothing is listening', () async {
    final dead = AssistantSettings(
      baseUrl: 'http://127.0.0.1:${server.port + 1}/v1',
    );
    final status = await LocalAiService(dead).checkStatus();
    expect(status.isOnline, isFalse);
    expect(status.message, isNotNull);
  });
}
