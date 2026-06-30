import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class ScheduleNotFound extends StatelessWidget {
  const ScheduleNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        'No study plan yet.',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
