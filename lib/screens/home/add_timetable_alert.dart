import 'package:flutter/material.dart';

import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/theme/theme.dart';

Future<AddTimetableAlertAction?> showAddTimetableAlert(BuildContext context) {
  return showDialog<AddTimetableAlertAction>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Update latest marks?'),
        content: const Text(
          'Before scheduling an accurate timetable for the upcoming week, '
          'please make sure your latest school and tuition exam marks are '
          'updated. These marks help us plan your study time better.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.colors.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(AddTimetableAlertAction.addMarks);
            },
            child: Text(
              'Add marks',
              style: TextStyle(color: context.colors.primary),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(AddTimetableAlertAction.schedule);
            },
            child: const Text('Schedule'),
          ),
        ],
      );
    },
  );
}
