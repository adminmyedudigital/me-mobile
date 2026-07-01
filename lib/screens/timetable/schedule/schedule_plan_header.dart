import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/timetable/schedule/schedule_card_action_button.dart';
import 'package:me_mobile/controllers/schedule_timetable_controller.dart';

class SchedulePlanHeader extends StatelessWidget {
  const SchedulePlanHeader({
    super.key,
    required this.date,
    required this.onAdd,
    required this.canAdd,
    this.onEdit,
    this.onDelete,
  });

  final bool canAdd;
  final DateTime date;
  final VoidCallback onAdd;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleTimetableController>();
    final colors = context.colors;
    final hasPlan = onEdit != null && onDelete != null;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
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
          if (hasPlan) ...[
            ScheduleCardActionButton(
              tooltip: 'Delete',
              onPressed: onDelete,
              icon: Icons.delete_outline,
              color: colors.accentRed,
            ),
            const SizedBox(width: AppSpacing.xs),
            ScheduleCardActionButton(
              tooltip: 'Edit',
              onPressed: onEdit,
              icon: Icons.edit_outlined,
              color: colors.ink,
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          ScheduleCardActionButton(
            tooltip: 'Add plan for this day',
            onPressed: canAdd ? onAdd : null,
            icon: Icons.add_circle_outline_rounded,
            color: colors.accentOrange,
          ),
        ],
      ),
    );
  }
}
