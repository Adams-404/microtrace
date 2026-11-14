import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/floating_nav_bar.dart';
import '../../features/analysis/analysis_workspace_screen.dart';
import '../../features/assistant/assistant_screen.dart';
import '../../features/capture/capture_workspace_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/image_review/image_review_screen.dart';
import '../../features/model_library/model_library_screen.dart';
import '../../features/modules/modules_library_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/reports/report_preview_screen.dart';
import '../../features/results/results_review_screen.dart';
import '../../features/sessions/new_session_screen.dart';
import '../../features/sessions/session_detail_screen.dart';
import '../../features/sessions/session_history_screen.dart';
import '../../features/settings/settings_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return _ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/capture',
            builder: (context, state) => const CaptureWorkspaceScreen(),
          ),
          GoRoute(
            path: '/sessions',
            builder: (context, state) => const SessionHistoryScreen(),
          ),
          GoRoute(
            path: '/modules',
            builder: (context, state) => const ModulesLibraryScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/capture/:sessionId',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId'];
          return CaptureWorkspaceScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: '/new-session',
        builder: (context, state) => const NewSessionScreen(),
      ),
      GoRoute(
        path: '/session/:sessionId',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return SessionDetailScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: '/session/:sessionId/image/:imageId',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          final imageId = state.pathParameters['imageId']!;
          return ImageReviewScreen(sessionId: sessionId, imageId: imageId);
        },
      ),
      GoRoute(
        path: '/session/:sessionId/image/:imageId/analysis',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          final imageId = state.pathParameters['imageId']!;
          return AnalysisWorkspaceScreen(
            sessionId: sessionId,
            imageId: imageId,
          );
        },
      ),
      GoRoute(
        path: '/session/:sessionId/image/:imageId/results',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          final imageId = state.pathParameters['imageId']!;
          return ResultsReviewScreen(sessionId: sessionId, imageId: imageId);
        },
      ),
      GoRoute(
        path: '/session/:sessionId/report',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return ReportPreviewScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: '/assistant',
        builder: (context, state) {
          final sessionId = state.uri.queryParameters['session'];
          return AssistantScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: '/models',
        builder: (context, state) => const ModelLibraryScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

class _ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithNavBar({required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == '/') return 0;
    if (location.startsWith('/capture')) return 1;
    if (location.startsWith('/sessions')) return 2;
    if (location.startsWith('/modules')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/capture');
        break;
      case 2:
        context.go('/sessions');
        break;
      case 3:
        context.go('/modules');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: selectedIndex,
        onTap: (idx) => _onItemTapped(idx, context),
        items: const [
          FloatingNavItem(icon: Icons.dashboard_outlined, label: 'Overview'),
          FloatingNavItem(icon: Icons.camera_alt_outlined, label: 'Capture'),
          FloatingNavItem(icon: Icons.folder_outlined, label: 'Sessions'),
          FloatingNavItem(icon: Icons.extension_outlined, label: 'Modules'),
        ],
      ),
    );
  }
}
