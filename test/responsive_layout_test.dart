import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:microtrace/app/app.dart';
import 'package:microtrace/features/reports/report_preview_screen.dart';
import 'package:microtrace/features/sessions/session_detail_screen.dart';
import 'package:microtrace/features/sessions/session_history_screen.dart';
import 'package:microtrace/shared/models/microscopy_image.dart';
import 'package:microtrace/shared/models/quality_metrics.dart';
import 'package:microtrace/shared/models/session.dart';
import 'package:microtrace/shared/services/session_repository.dart';

MicroscopySession _seedSession(ProviderContainer container) {
  final session = MicroscopySession(
    id: 'responsive_session_001',
    title: 'Very Long Specimen Title That Should Wrap Responsively Without Horizontal Overflow',
    specimenCode: 'MYC-2026-LONG-SPECIMEN-CODE-001',
    specimenType: 'SDA Micro-Culture Mount (LCB)',
    moduleId: 'module_mycology_v1',
    moduleName: 'Fungal Patch Classification',
    captureProfile: '40x Achromat • Brightfield • Lactophenol Cotton Blue',
    createdAt: DateTime(2026, 11, 23, 17, 30),
    images: [
      MicroscopyImage(
        id: 'img_001',
        sessionId: 'responsive_session_001',
        fieldIndex: 1,
        assetPath: 'assets/sample_images/microscopy_aspergillus.png',
        capturedAt: DateTime(2026, 11, 23, 17, 31),
        qualityMetrics: QualityMetrics.nominal(),
      ),
      MicroscopyImage(
        id: 'img_002',
        sessionId: 'responsive_session_001',
        fieldIndex: 2,
        assetPath: 'assets/sample_images/microscopy_candida.png',
        capturedAt: DateTime(2026, 11, 23, 17, 32),
        qualityMetrics: QualityMetrics.nominal(),
      ),
    ],
  );
  container.read(sessionRepositoryProvider.notifier).state = [session];
  return session;
}

void main() {
  group('Responsive Layout & No Horizontal Overflow', () {
    testWidgets('SessionHistoryScreen renders filter chips in Wrap without horizontal overflow', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final container = ProviderContainer();
      _seedSession(container);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: SessionHistoryScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // All filter chips should be present and rendered
      expect(find.widgetWithText(FilterChip, 'ALL SESSIONS'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'IN PROGRESS'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'COMPLETED'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'REVIEWED'), findsOneWidget);

      // Verify Wrap is used for filter chips
      expect(find.byType(Wrap), findsWidgets);
    });

    testWidgets('SessionDetailScreen renders metadata without horizontal overflow on narrow screen', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final container = ProviderContainer();
      final session = _seedSession(container);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: SessionDetailScreen(sessionId: session.id),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(session.specimenCode), findsWidgets);
      expect(find.text('Preparation: ${session.specimenType}'), findsOneWidget);
    });

    testWidgets('ReportPreviewScreen renders header without horizontal overflow on narrow screen', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final container = ProviderContainer();
      final session = _seedSession(container);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: ReportPreviewScreen(sessionId: session.id),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('MICROBIOLOGY OBSERVATION REPORT'), findsOneWidget);
    });

    testWidgets('MicrotraceApp renders cleanly on wide desktop screen and mobile screen', (
      WidgetTester tester,
    ) async {
      // Test mobile
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(const ProviderScope(child: MicrotraceApp()));
      await tester.pumpAndSettle();
      expect(find.textContaining('Start a microscopy'), findsOneWidget);

      // Test wide desktop
      tester.view.physicalSize = const Size(1440, 900);
      await tester.pumpWidget(const ProviderScope(child: MicrotraceApp()));
      await tester.pumpAndSettle();
      expect(find.textContaining('Start a microscopy'), findsOneWidget);

      tester.view.resetPhysicalSize();
    });
  });
}
