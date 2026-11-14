import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:microtrace/app/app.dart';
import 'package:microtrace/core/widgets/ai_mark.dart';

void main() {
  testWidgets('MICROTRACE workstation app boots up and renders dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MicrotraceApp()));
    await tester.pumpAndSettle();

    // Hero action, telemetry sections and the floating top actions
    expect(find.textContaining('Start a microscopy'), findsOneWidget);
    expect(find.text('WORKSTATION TELEMETRY'), findsOneWidget);
    expect(find.text('New session'), findsOneWidget);
    expect(find.byTooltip('Workstation settings'), findsOneWidget);
    expect(find.byTooltip('Local AI copilot'), findsOneWidget);
    expect(find.byType(AiMark), findsWidgets);
  });

  testWidgets('settings opens as a bottom sheet from the dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MicrotraceApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.tune_rounded).last);
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('PREFERENCES & LOCAL AI'), findsOneWidget);
    expect(find.byTooltip('Close settings'), findsOneWidget);
    expect(find.text('APPEARANCE'), findsOneWidget);
    expect(find.text('LOCAL AI COPILOT'), findsOneWidget);
  });
}
