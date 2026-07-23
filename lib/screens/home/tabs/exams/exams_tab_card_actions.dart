import 'package:flutter/material.dart';

import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/theme/theme.dart';

part 'exam_card_action_item.dart';

class ExamsTabCardActions extends StatelessWidget {
  const ExamsTabCardActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PopupMenuButton<ExamCardAction>(
      tooltip: 'Actions',
      enabled: onEdit != null || onDelete != null,
      color: colors.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert_rounded, color: colors.charcoal),
      onSelected: (action) {
        switch (action) {
          case ExamCardAction.edit:
            onEdit?.call();
          case ExamCardAction.delete:
            onDelete?.call();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ExamCardAction.edit,
          enabled: onEdit != null,
          child: _ExamCardActionItem(
            icon: Icons.edit_outlined,
            label: 'Edit',
            color: colors.primary,
          ),
        ),
        PopupMenuItem(
          value: ExamCardAction.delete,
          enabled: onDelete != null,
          child: _ExamCardActionItem(
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            color: colors.accentRed,
          ),
        ),
      ],
    );
  }
}
