import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class ScheduleMetaChip extends StatelessWidget {
  const ScheduleMetaChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceDeep.withValues(alpha: 0.72),
        borderRadius: AppRadius.pill,
        border: Border.all(color: context.colors.hairlineStrong),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: context.colors.ash),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: context.colors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
