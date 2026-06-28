import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class EmptyTimetable extends StatelessWidget {
  const EmptyTimetable({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.surfaceDeep.withValues(alpha: 0.78),
        borderRadius: AppRadius.card,
        border: Border.all(color: colors.accentOrange.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: colors.accentOrangeGlow.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors.accentOrange.withValues(alpha: 0.12),
              borderRadius: AppRadius.card,
              border: Border.all(
                color: colors.accentOrange.withValues(alpha: 0.24),
              ),
            ),
            child: Icon(
              Icons.event_available_rounded,
              color: colors.accentOrange,
              size: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No events scheduled',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colors.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'This time slot is free for now.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.charcoal,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
