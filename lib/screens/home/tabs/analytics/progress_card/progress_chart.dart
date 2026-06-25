import 'package:flutter/material.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/progress_bar.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/progress_ring.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/study_progress_summary.dart';
import 'package:me_mobile/theme/theme.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key, required this.progressItem});

  final StudyProgressSummary progressItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProgressRing(
          label: 'Total',
          percent:
              ((progressItem.studyProgress + progressItem.examProgress) / 2)
                  .toInt(),
          color: context.colors.accentRed,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            children: [
              ProgressBar(
                label: 'Study',
                percent: progressItem.studyProgress,
                color: context.colors.accentBlue,
              ),
              const SizedBox(height: AppSpacing.md),
              ProgressBar(
                label: 'Exam',
                percent: progressItem.examProgress,
                color: context.colors.accentBlue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
