import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/controllers/schedule_timetable_controller.dart';

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

    return Row(
      children: [
        Container(
          width: 4,
          height: 28,
          decoration: BoxDecoration(
            color: colors.accentOrange,
            borderRadius: AppRadius.pill,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            controller.dateLabel(date),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: colors.ink),
          ),
        ),
        IconButton(
          tooltip: 'Add plan for this day',
          onPressed: canAdd ? onAdd : null,
          icon: Icon(
            Icons.add_circle_outline_rounded,
            color: colors.accentOrange,
          ),
        ),
      ],
    );
  }
}
