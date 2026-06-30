import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/schedule_timetable_controller.dart';

class ScheduleTimetableCard extends StatelessWidget {
  const ScheduleTimetableCard({
    super.key,
    required this.item,
    required this.controller,
    required this.onEdit,
    required this.onDelete,
  });

  final ScheduleTimetableItem item;
  final ScheduleTimetableController controller;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final kindColor = switch (item.kind) {
      'Revision' => colors.accentGreen,
      'Exam paper' => colors.accentBlue,
      _ => colors.accentOrange,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.subjectName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    item.topicName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SchedulePlanChip(label: item.kind, color: kindColor),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            ScheduleMetaChip(
              icon: Icons.schedule_outlined,
              label: controller.timeLabel(item.startHour),
            ),
            ScheduleMetaChip(
              icon: Icons.timer_outlined,
              label: controller.durationLabel(item.studyHours),
            ),
            ScheduleMetaChip(
              icon: item.isSystemGenerated
                  ? Icons.auto_awesome_outlined
                  : Icons.edit_note_outlined,
              label: item.isSystemGenerated ? 'Generated' : 'Custom',
            ),
          ],
        ),
        if (item.suggestion.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          SchedulePlanSuggestion(item: item),
        ],
        const SizedBox(height: AppSpacing.sm),
        ScheduleCardActionContainer(onDelete: onDelete, onEdit: onEdit),
      ],
    );
  }
}
