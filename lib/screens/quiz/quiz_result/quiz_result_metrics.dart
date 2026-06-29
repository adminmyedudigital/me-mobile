import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';

class QuizResultMetrics extends StatelessWidget {
  const QuizResultMetrics({
    super.key,
    required this.correctAnswerCount,
    required this.wrongAnswerCount,
    required this.questionCount,
  });

  final int correctAnswerCount;
  final int wrongAnswerCount;
  final int questionCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: ResultMetricCard(
            icon: Icons.check_circle_rounded,
            label: 'Correct',
            value: correctAnswerCount.toString(),
            color: colors.accentGreen,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ResultMetricCard(
            icon: Icons.cancel_rounded,
            label: 'Wrong',
            value: wrongAnswerCount.toString(),
            color: colors.accentRed,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ResultMetricCard(
            icon: Icons.quiz_rounded,
            label: 'Total',
            value: questionCount.toString(),
            color: colors.accentBlue,
          ),
        ),
      ],
    );
  }
}
