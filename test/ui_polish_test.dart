import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:microtrace/features/image_review/image_review_screen.dart';
import 'package:microtrace/features/reports/report_preview_screen.dart';
import 'package:microtrace/features/sessions/new_session_screen.dart';
import 'package:microtrace/shared/services/session_repository.dart';

void main() {
  testWidgets('NewSessionScreen renders modules with INSTALLED and ROADMAP badges', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: NewSessionScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('INSTALLED'), findsOneWidget);
    expect(find.text('ROADMAP'), findsWidgets);

    final button = find.text('PROCEED TO CAPTURE WORKSPACE');
    await tester.scrollUntilVisible(
      button,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(button, findsOneWidget);
  });

  testWidgets('ReportPreviewScreen renders without outer card box', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final container = ProviderContainer();
    final firstSession = container.read(sessionRepositoryProvider).first;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: ReportPreviewScreen(sessionId: firstSession.id),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('MICROBIOLOGY OBSERVATION REPORT'), findsOneWidget);
    expect(find.text('SPECIMEN & OPTICAL TELEMETRY'), findsOneWidget);

    final exportButton = find.text('EXPORT PDF REPORT');
    await tester.scrollUntilVisible(
      exportButton,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(exportButton, findsOneWidget);
    expect(find.text('JSON EXPORT'), findsOneWidget);
  });

  testWidgets('ImageReviewScreen renders USABLE FIELD and FLAG RECAPTURE options', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final container = ProviderContainer();
    final firstSession = container.read(sessionRepositoryProvider).first;
    final firstImage = firstSession.images.first;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: ImageReviewScreen(
            sessionId: firstSession.id,
            imageId: firstImage.id,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final usable = find.text('USABLE FIELD');
    await tester.scrollUntilVisible(
      usable,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(usable, findsOneWidget);
    expect(find.text('FLAG RECAPTURE'), findsOneWidget);
    expect(find.text('SAVE FIELD OBSERVATIONS'), findsOneWidget);
  });
}
