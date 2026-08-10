import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/controllers/schedule/schedule_timetable_controller.dart';

class SchedulePlanHeader extends StatelessWidget {
  const SchedulePlanHeader({
    super.key,
    required this.date,
    required this.onAdd,
    required this.canAdd,
  });

  final bool canAdd;
  final DateTime date;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleTimetableController>();
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surfaceDeep.withValues(alpha: 0.72),
        borderRadius: AppRadius.input,
        border: Border.all(color: colors.hairlineStrong),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.accentOrangeGlow,
              borderRadius: AppRadius.button,
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 19,
              color: colors.accentOrange,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.dateLabel(date),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${_weekdays[date.weekday - 1]} study plans',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: colors.mute),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          TextButton.icon(
            onPressed: canAdd ? onAdd : null,
            style: TextButton.styleFrom(
              foregroundColor: colors.accentOrange,
              backgroundColor: colors.accentOrangeGlow,
              disabledForegroundColor: colors.mute,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
            ),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text('Add'),
          ),
        ],
      ),
    );
  }

  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
}
