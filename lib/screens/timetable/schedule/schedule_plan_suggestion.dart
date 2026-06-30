import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/controllers/schedule_timetable_controller.dart';

class SchedulePlanSuggestion extends StatelessWidget {
  const SchedulePlanSuggestion({super.key, required this.item});

  final ScheduleTimetableItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceDeep.withValues(alpha: 0.64),
        borderRadius: AppRadius.input,
        border: Border.all(color: colors.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb_outline, color: colors.accentYellow, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                item.suggestion,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.charcoal,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
