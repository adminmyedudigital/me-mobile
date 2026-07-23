import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class ExamsTabSwipeAction extends StatelessWidget {
  const ExamsTabSwipeAction({
    super.key,
    required this.alignment,
    required this.icon,
    required this.label,
    required this.isDestructive,
  });

  final Alignment alignment;
  final IconData icon;
  final String label;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final actionColor = isDestructive ? colors.accentRed : colors.accentBlue;
    final isRightAligned = alignment == Alignment.centerRight;

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: actionColor.withValues(alpha: 0.16),
        borderRadius: AppRadius.button,
        border: Border.all(color: actionColor.withValues(alpha: 0.32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isRightAligned) ...[
            Text(
              label,
              style: context.textTheme.labelLarge?.copyWith(color: actionColor),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Icon(icon, color: actionColor),
          if (!isRightAligned) ...[
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: context.textTheme.labelLarge?.copyWith(color: actionColor),
            ),
          ],
        ],
      ),
    );
  }
}
