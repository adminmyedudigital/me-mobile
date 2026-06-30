import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/schedule_timetable_controller.dart';

class ScheduleWeekHeader extends StatelessWidget {
  const ScheduleWeekHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleTimetableController>();
    final colors = context.colors;
    final weekStart = controller.weekStart.value;
    final weekEnd = weekStart.add(const Duration(days: 6));

    return Row(
      children: [
        ScheduleWeekNavButton(
          tooltip: 'Previous week',
          onPressed: controller.canMovePrevious
              ? () => controller.moveWeek(-1)
              : null,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Text(
            controller.weekRangeLabel(weekStart, weekEnd),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: colors.ink),
          ),
        ),
        ScheduleWeekNavButton(
          tooltip: 'Next week',
          onPressed: controller.canMoveNext
              ? () => controller.moveWeek(1)
              : null,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}
