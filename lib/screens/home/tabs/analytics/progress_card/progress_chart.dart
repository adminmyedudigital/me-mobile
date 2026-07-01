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
    final totalProgressColor = _totalProgressColor(context);

    return Row(
      children: [
        ProgressRing(
          label: 'Total',
          percent: progressItem.totalProgress,
          color: totalProgressColor,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            children: [
              ProgressBar(
                label: 'Study',
                percent: progressItem.studyProgress,
                color: _progressBarColor(context, progressItem.studyProgress),
              ),
              const SizedBox(height: AppSpacing.md),
              ProgressBar(
                label: 'Exam',
                percent: progressItem.examProgress,
                color: _progressBarColor(context, progressItem.examProgress),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _totalProgressColor(BuildContext context) {
    final totalProgress = progressItem.totalProgress.clamp(0, 100);

    if (totalProgress <= 33) {
      return context.colors.accentRed;
    }

    if (totalProgress <= 75) {
      return context.colors.accentBlue;
    }

    return context.colors.accentGreen;
  }

  Color _progressBarColor(BuildContext context, int percent) {
    final totalProgress = percent.clamp(0, 100);

    if (totalProgress <= 33) {
      return context.colors.accentRed;
    }

    if (totalProgress <= 75) {
      return context.colors.accentBlue;
    }

    return context.colors.accentGreen;
  }
}
