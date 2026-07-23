import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/widgets.dart';

Future<bool> showExamDeleteConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) {
          final colors = context.colors;

          return AlertDialog(
            title: const Text('Delete exam result?'),
            content: const Text(
              'This exam result will be permanently removed.',
              textAlign: TextAlign.justify,
            ),
            actions: [
              MEButton(
                label: 'Cancel',
                fullWidth: true,
                backgroundColor: colors.surfaceCard,
                foregroundColor: colors.ink,
                onPressed: () => Navigator.of(context).pop(false),
              ),
              const SizedBox(height: AppSpacing.sm),
              MEButton(
                label: 'Delete',
                icon: Icons.delete_outline_rounded,
                fullWidth: true,
                backgroundColor: colors.accentRed,
                foregroundColor: colors.surfaceLight,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      ) ??
      false;
}
