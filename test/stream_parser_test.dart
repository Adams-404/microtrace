import 'package:flutter_test/flutter_test.dart';
import 'package:microtrace/shared/services/stream_parser.dart';

void main() {
  test('parses OpenAI-style SSE deltas across chunk boundaries', () {
    final parser = StreamParser();
    final deltas = <String>[];

    // Split mid-JSON and mid-event to exercise buffering.
    deltas.addAll(
      parser.add(
        'data: {"choices":[{"delta":{"content":"Asper"}}]}\n\ndata: {"choi',
      ),
    );
    deltas.addAll(
      parser.add('ces":[{"delta":{"content":"gillus"}}]}\n\ndata: [DONE]\n\n'),
    );

    expect(deltas, ['Asper', 'gillus']);
    expect(parser.done, isTrue);
  });

  test('surfaces server error payloads', () {
    final parser = StreamParser();
    final deltas = parser.add(
      'data: {"error":{"message":"model not loaded"}}\n\n',
    );

    expect(deltas, isEmpty);
    expect(parser.done, isTrue);
    expect(parser.errorMessage, 'model not loaded');
  });

  test('falls back to plain text lines', () {
    final parser = StreamParser(rawMode: true);
    expect(parser.add('hello'), ['hello']);
    expect(parser.add(''), isEmpty);
  });
}
