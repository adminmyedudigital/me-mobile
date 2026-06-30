import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';

class ScheduleCardActionContainer extends StatelessWidget {
  const ScheduleCardActionContainer({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ScheduleCardActionButton(
          tooltip: 'Edit',
          onPressed: onEdit,
          icon: Icons.edit_outlined,
          color: colors.ink,
        ),
        const SizedBox(width: AppSpacing.xs),
        ScheduleCardActionButton(
          tooltip: 'Delete',
          onPressed: onDelete,
          icon: Icons.delete_outline,
          color: colors.accentRed,
        ),
      ],
    );
  }
}
