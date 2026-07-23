import 'package:flutter/material.dart';

import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/screens/screens.dart';

class ExamsTabCard extends StatelessWidget {
  const ExamsTabCard({super.key, required this.exam, required this.dateLabel});

  final ExamModel exam;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final accentColor = switch (exam.examType) {
      ExamType.school => context.colors.accentBlue,
      ExamType.tuition => context.colors.accentGreen,
    };
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Container(
      decoration: BoxDecoration(
        color: isLightTheme ? colors.surfaceDeep : colors.surfaceDeep,
        borderRadius: AppRadius.button,
        border: Border.all(
          color: isLightTheme ? colors.hairline : colors.hairlineStrong,
        ),

        boxShadow: [
          if (isLightTheme)
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.subjectName,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: context.colors.ink),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        dateLabel,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (exam.topicNames.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          exam.topicNames.join(', '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                ExamsTabTypeChip(
                  label: exam.examType.label,
                  color: accentColor,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Divider(color: colors.stone),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: ExamsTabMetric(
                    label: 'Achieved marks',
                    value: '${exam.achievedMarks} / ${exam.examMarks}',
                  ),
                ),
                Expanded(
                  child: ExamsTabMetric(
                    label: 'Percentage',
                    value: '${exam.scorePercent}%',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
