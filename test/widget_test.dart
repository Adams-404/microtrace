import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:microtrace/app/app.dart';

void main() {
  testWidgets('MICROTRACE workstation app boots up and renders dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MicrotraceApp()));

    // Initial pump and settle
    await tester.pumpAndSettle();

    // Verify brand, hero action and telemetry sections render
    expect(find.text('MICROTRACE'), findsWidgets);
    expect(find.textContaining('Start a microscopy'), findsOneWidget);
    expect(find.text('Workstation telemetry'), findsOneWidget);
    expect(find.text('New session'), findsOneWidget);
  });
}
