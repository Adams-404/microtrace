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

    // Hero action, telemetry sections and the lone floating settings action
    expect(find.textContaining('Start a microscopy'), findsOneWidget);
    expect(find.text('WORKSTATION TELEMETRY'), findsOneWidget);
    expect(find.text('New session'), findsOneWidget);
    expect(find.byTooltip('Workstation settings'), findsOneWidget);
  });
}
