import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class QuizResultSummary extends StatelessWidget {
  const QuizResultSummary({
    super.key,
    required this.correctAnswerCount,
    required this.questionCount,
    required this.progressPercent,
  });

  final int correctAnswerCount;
  final int questionCount;
  final double progressPercent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final summary = progressPercent >= 80
        ? 'Strong round. Keep this topic warm with a short review later.'
        : progressPercent >= 50
        ? 'Good start. Review the missed ideas once before moving on.'
        : 'This topic needs another pass. Revisit the cards and retry.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.accentOrangeGlow.withValues(alpha: 0.28),
        borderRadius: AppRadius.button,
        border: Border.all(color: colors.accentOrange.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$correctAnswerCount correct out of $questionCount questions',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            summary,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.body),
          ),
        ],
      ),
    );
  }
}
