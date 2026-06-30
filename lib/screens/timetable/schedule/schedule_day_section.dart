import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/schedule_timetable_controller.dart';

class ScheduleDaySection extends StatelessWidget {
  const ScheduleDaySection({
    super.key,
    required this.date,
    required this.items,
    required this.controller,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.canAdd,
  });

  final DateTime date;
  final List<ScheduleTimetableItem> items;
  final ScheduleTimetableController controller;
  final VoidCallback onAdd;
  final ValueChanged<ScheduleTimetableItem> onEdit;
  final ValueChanged<int> onDelete;
  final bool canAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: AppRadius.card,
        border: Border.all(color: colors.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppRadius.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SchedulePlanHeader(canAdd: canAdd, date: date, onAdd: onAdd),
            if (items.isEmpty)
              ScheduleNotFound()
            else
              for (final item in items) ...[
                ScheduleTimetableCard(
                  item: item,
                  controller: controller,
                  onEdit: () => onEdit(item),
                  onDelete: () => onDelete(item.id),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
          ],
        ),
      ),
    );
  }
}
