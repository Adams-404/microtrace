import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';
import '../../app/theme/app_typography.dart';

/// Eyebrow + optional trailing action, used to separate dashboard sections.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTypography.label(t.textMuted),
          ),
        ),
        ?trailing,
        if (actionLabel != null)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionLabel!,
                      style: AppTypography.caption(t.accent).copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 11, color: t.accent),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
