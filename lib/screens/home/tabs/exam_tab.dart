import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class ExamTab extends StatelessWidget {
  const ExamTab({super.key});

  @override
  Widget build(BuildContext context) {
    final exams = [
      ('Mathematics', 'Today, 10:00 AM', context.colors.accentBlue),
      ('Science', 'Tomorrow, 02:30 PM', context.colors.accentGreen),
      ('English', 'Friday, 09:00 AM', context.colors.accentYellow),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        Text('Upcoming exams', style: context.textTheme.displaySmall),
        const SizedBox(height: AppSpacing.xxl),
        for (final exam in exams) ...[
          Card(
            child: ListTile(
              leading: Icon(Icons.assignment, color: exam.$3),
              title: Text(exam.$1),
              subtitle: Text(exam.$2),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
