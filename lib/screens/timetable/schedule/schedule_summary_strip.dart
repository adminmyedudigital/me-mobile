import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/schedule_timetable_controller.dart';

class ScheduleSummaryStrip extends StatelessWidget {
  const ScheduleSummaryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleTimetableController>();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ScheduleSummaryTile(
                label: 'Plans',
                value: controller.items.length.toString(),
                icon: Icons.event_note_outlined,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: ScheduleSummaryTile(
                label: 'Hours',
                value: controller.durationLabel(controller.totalStudyHours),
                icon: Icons.timer_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: ScheduleSummaryTile(
                label: 'Revision',
                value: controller.revisionCount.toString(),
                icon: Icons.restart_alt_rounded,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: ScheduleSummaryTile(
                label: 'Papers',
                value: controller.examPrepCount.toString(),
                icon: Icons.assignment_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
