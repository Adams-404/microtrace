import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_tokens.dart';
import '../../app/theme/app_typography.dart';

class FloatingNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const FloatingNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// Floating glass capsule navigation bar.
///
/// Sits above the scroll surface so content glides underneath it. The active
/// destination gets a soft accent pill, a filled icon variant and a heavier
/// label — the only motion is a 220ms size/color settle.
class FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<FloatingNavItem> items;

  const FloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, 14 + MediaQuery.viewPaddingOf(context).bottom),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: t.isDark ? 0.55 : 0.12),
              blurRadius: 30,
              offset: const Offset(0, 14),
              spreadRadius: -6,
            ),
            BoxShadow(
              color: t.accent.withValues(alpha: t.isDark ? 0.05 : 0.08),
              blurRadius: 24,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
            child: Container(
              height: 66,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                color: t.surface.withValues(alpha: t.isDark ? 0.78 : 0.86),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: t.isDark
                      ? Colors.white.withValues(alpha: 0.07)
                      : t.border,
                ),
              ),
              child: Row(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      child: _NavDestination(
                        item: items[i],
                        selected: i == selectedIndex,
                        onTap: () {
                          if (i == selectedIndex) return;
                          HapticFeedback.selectionClick();
                          onTap(i);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavDestination extends StatelessWidget {
  final FloatingNavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavDestination({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(19),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? t.accentSoft : Colors.transparent,
              borderRadius: BorderRadius.circular(19),
              border: Border.all(
                color: selected
                    ? t.accent.withValues(alpha: 0.28)
                    : Colors.transparent,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: selected ? 1.0 : 0.96,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: Icon(
                    selected ? item.activeIcon : item.icon,
                    size: 21,
                    color: selected ? t.accent : t.textMuted,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption(
                    selected ? t.accent : t.textMuted,
                  ).copyWith(
                    fontSize: 10,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: 0.1,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
