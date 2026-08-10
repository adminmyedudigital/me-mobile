import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/schedule/schedule_timetable_controller.dart';

class ScheduleTimetableCard extends StatelessWidget {
  const ScheduleTimetableCard({
    super.key,
    required this.item,
    required this.controller,
    required this.onEdit,
    required this.onDelete,
    required this.showDivider,
  });

  final ScheduleTimetableItem item;
  final ScheduleTimetableController controller;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final kindColor = switch (item.kind) {
      'Revision' => colors.accentGreen,
      'Exam paper' || 'Exam Preparation' => colors.accentBlue,
      _ => colors.accentOrange,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                item.subjectName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: colors.ink),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            ScheduleCardActionContainer(onEdit: onEdit, onDelete: onDelete),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (item.topicName.isNotEmpty)
          Text(
            item.topicName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (item.subTopicName.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            item.subTopicName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            SchedulePlanChip(label: item.kind, color: kindColor),
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
        if (showDivider) ...[
          const SizedBox(height: AppSpacing.sm),
          Divider(height: 1, color: colors.hairline),
        ],
      ],
    );
  }
}
