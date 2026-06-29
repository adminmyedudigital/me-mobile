import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class QuizAnswerPanel extends StatelessWidget {
  const QuizAnswerPanel({
    super.key,
    required this.answer,
    required this.isCorrect,
  });

  final String answer;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accentColor = isCorrect ? colors.accentGreen : colors.accentOrange;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: AppRadius.card,
        border: Border.all(color: accentColor.withValues(alpha: 0.34)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCorrect ? 'Correct' : 'Correct answer',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: accentColor),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            answer,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.body),
          ),
        ],
      ),
    );
  }
}
