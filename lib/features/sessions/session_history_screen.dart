import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/haptics.dart';
import '../../core/widgets/scientific_app_bar.dart';
import '../../core/widgets/scientific_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/session.dart';
import '../../shared/services/session_repository.dart';

class SessionHistoryScreen extends ConsumerStatefulWidget {
  const SessionHistoryScreen({super.key});

  @override
  ConsumerState<SessionHistoryScreen> createState() =>
      _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends ConsumerState<SessionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  SessionStatus? _selectedStatusFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allSessions = ref.watch(sessionRepositoryProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final query = _searchController.text.trim().toLowerCase();
    final filteredSessions = allSessions.where((s) {
      final matchesSearch =
          query.isEmpty ||
          s.title.toLowerCase().contains(query) ||
          s.specimenCode.toLowerCase().contains(query) ||
          s.specimenType.toLowerCase().contains(query);

      final matchesStatus =
          _selectedStatusFilter == null || s.status == _selectedStatusFilter;

      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: ScientificAppBar(
        title: 'Session History',
        subtitle: 'LOCAL MICROSCOPY ARCHIVE',
        actions: [
          IconButton(
            tooltip: 'New Session',
            icon: const Icon(Icons.add, size: 22, color: AppColors.signal),
            onPressed: () => context.push('/new-session'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by specimen ID, title, or type...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        selected: _selectedStatusFilter == null,
                        label: const Text('ALL SESSIONS'),
                        onSelected: (_) {
                          Haptics.select();
                          setState(() => _selectedStatusFilter = null);
                        },
                      ),
                      const SizedBox(width: 6),
                      FilterChip(
                        selected:
                            _selectedStatusFilter == SessionStatus.inProgress,
                        label: const Text('IN PROGRESS'),
                        onSelected: (_) {
                          Haptics.select();
                          setState(
                            () => _selectedStatusFilter =
                                SessionStatus.inProgress,
                          );
                        },
                      ),
                      const SizedBox(width: 6),
                      FilterChip(
                        selected:
                            _selectedStatusFilter == SessionStatus.completed,
                        label: const Text('COMPLETED'),
                        onSelected: (_) {
                          Haptics.select();
                          setState(
                            () =>
                                _selectedStatusFilter = SessionStatus.completed,
                          );
                        },
                      ),
                      const SizedBox(width: 6),
                      FilterChip(
                        selected:
                            _selectedStatusFilter == SessionStatus.reviewed,
                        label: const Text('REVIEWED'),
                        onSelected: (_) {
                          Haptics.select();
                          setState(
                            () =>
                                _selectedStatusFilter = SessionStatus.reviewed,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // Session Records List
          Expanded(
            child: filteredSessions.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: textSecondary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No matching sessions found',
                            style: AppTypography.title(textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try adjusting your search query or status filter.',
                            style: AppTypography.caption(textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 132),
                    itemCount: filteredSessions.length,
                    itemBuilder: (context, index) {
                      final session = filteredSessions[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ScientificCard(
                          onTap: () => context.push('/session/${session.id}'),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        session.specimenCode,
                                        style: AppTypography.technicalMono(
                                          AppColors.signal,
                                          fontSize: 13,
                                          weight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      StatusBadge(
                                        label: session.status.displayName,
                                        type:
                                            session.status ==
                                                SessionStatus.reviewed
                                            ? BadgeType.pass
                                            : (session.status ==
                                                      SessionStatus.completed
                                                  ? BadgeType.humanObservation
                                                  : BadgeType.warning),
                                        isCompact: true,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    Formatters.formatDateTime(
                                      session.createdAt,
                                    ),
                                    style: AppTypography.caption(textSecondary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                session.title,
                                style: AppTypography.title(textPrimary),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.biotech,
                                    size: 14,
                                    color: textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    session.specimenType,
                                    style: AppTypography.caption(textSecondary),
                                  ),
                                  const SizedBox(width: 14),
                                  Icon(
                                    Icons.photo_library_outlined,
                                    size: 14,
                                    color: textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${session.images.length} fields',
                                    style: AppTypography.caption(textSecondary),
                                  ),
                                ],
                              ),
                              if (session.images.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                // Micro thumbnails strip
                                SizedBox(
                                  height: 44,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: session.images.length,
                                    itemBuilder: (context, imgIdx) {
                                      final img = session.images[imgIdx];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 6,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          child: Image.asset(
                                            img.assetPath,
                                            width: 44,
                                            height: 44,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
