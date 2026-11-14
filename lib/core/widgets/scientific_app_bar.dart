import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';
import '../../app/theme/app_typography.dart';
import 'status_badge.dart';

/// Transparent instrument header. Separation comes from spacing and the
/// floating nav, not a hard divider line.
class ScientificAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showOfflineBadge;

  const ScientificAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.showOfflineBadge = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return AppBar(
      leading: leading,
      leadingWidth: leading == null ? null : 68,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 66,
      titleSpacing: leading == null ? 20 : 4,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.title(t.textPrimary)
                      .copyWith(fontSize: 17, letterSpacing: -0.3),
                ),
              ),
              if (showOfflineBadge) ...[
                const SizedBox(width: 8),
                const StatusBadge(
                  label: 'Offline',
                  type: BadgeType.pass,
                  isCompact: true,
                ),
              ],
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(
              subtitle!.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.technicalMono(
                t.textMuted,
                fontSize: 8.5,
                weight: FontWeight.w500,
              ).copyWith(letterSpacing: 1.1),
            ),
          ],
        ],
      ),
      actions: actions == null
          ? null
          : [...actions!, const SizedBox(width: 12)],
    );
  }
}
