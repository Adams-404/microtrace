import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:microtrace/features/capture/capture_workspace_screen.dart';
import 'package:microtrace/shared/database/app_database.dart';
import 'package:microtrace/shared/database/database_provider.dart';
import 'package:microtrace/shared/services/file_storage_service.dart';
import 'package:microtrace/shared/services/session_repository.dart';

class FakeCameraPlatform extends CameraPlatform {
  final List<CameraDescription> cameras;
  FakeCameraPlatform({this.cameras = const []});

  @override
  Future<List<CameraDescription>> availableCameras() async => cameras;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    CameraPlatform.instance = FakeCameraPlatform();
  });

  testWidgets(
    'CaptureWorkspaceScreen renders controls, reticle, and executes capture in calibration mode',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2200);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testDb = AppDatabase(NativeDatabase.memory());
      addTearDown(testDb.close);

      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(testDb),
          fileStorageServiceProvider.overrideWithValue(
            FileStorageService(baseDirectoryPath: '/tmp/microtrace_test'),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Seed a test session
      final session = container
          .read(sessionRepositoryProvider.notifier)
          .createSession(
            title: 'Aspergillus Direct Mount',
            specimenCode: 'SPEC-TEST-001',
            specimenType: 'KOH Wet Mount',
            moduleId: 'mod_mycology_fungi',
            moduleName: 'Fungal Patch Classification',
            captureProfile: '40x Achromat • Brightfield',
            operatorLabel: 'Dr. Test',
            notes: 'Unit test capture verification.',
          );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: CaptureWorkspaceScreen(sessionId: session.id),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify header and specimen information
      expect(find.text('Capture Workspace'), findsOneWidget);
      expect(find.textContaining('SPEC-TEST-001'), findsOneWidget);

      // Verify optical zoom controls: 1.0x, 2.0x, 4.0x
      expect(find.text('1.0x'), findsOneWidget);
      expect(find.text('2.0x'), findsOneWidget);
      expect(find.text('4.0x'), findsOneWidget);

      // Tap 2.0x zoom
      await tester.tap(find.text('2.0x'));
      await tester.pumpAndSettle();

      // Verify shutter button exists
      final shutterFinder = find.byIcon(Icons.camera);
      expect(shutterFinder, findsOneWidget);

      // Trigger capture
      await tester.tap(shutterFinder);
      await tester.pump(); // start capture
      await tester.pump(const Duration(milliseconds: 300));

      // Verify an image was added to the session
      final updatedSessions = container.read(sessionRepositoryProvider);
      final updatedSession = updatedSessions.firstWhere(
        (s) => s.id == session.id,
      );
      expect(updatedSession.images.length, equals(1));
      expect(
        updatedSession.images.first.qualityMetrics.laplacianSharpness,
        greaterThan(0),
      );

      // Verify feedback banner was presented
      expect(find.textContaining('Field #1 Acquired'), findsOneWidget);

      // Advance past the 4.0s auto-dismiss timer
      await tester.pump(const Duration(seconds: 5));
    },
  );
}
