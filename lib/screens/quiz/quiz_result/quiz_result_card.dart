import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';

class QuizResultCard extends StatelessWidget {
  const QuizResultCard({
    super.key,
    required this.correctAnswerCount,
    required this.wrongAnswerCount,
    required this.questionCount,
    required this.progressPercent,
  });

  final int correctAnswerCount;
  final int wrongAnswerCount;
  final int questionCount;
  final double progressPercent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isLightTheme
            ? colors.surfaceCard
            : colors.surfaceElevated.withValues(alpha: 0.78),
        borderRadius: AppRadius.card,
        border: Border.all(
          color: colors.accentOrange.withValues(
            alpha: isLightTheme ? 0.18 : 0.28,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.accentOrangeGlow.withValues(
              alpha: isLightTheme ? 0.1 : 0.18,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const QuizResultHeader(),
          const SizedBox(height: AppSpacing.xl),
          Center(child: QuizScoreRing(progressPercent: progressPercent)),
          const SizedBox(height: AppSpacing.xl),
          QuizResultMetrics(
            correctAnswerCount: correctAnswerCount,
            wrongAnswerCount: wrongAnswerCount,
            questionCount: questionCount,
          ),
          const SizedBox(height: AppSpacing.lg),
          QuizResultSummary(
            correctAnswerCount: correctAnswerCount,
            questionCount: questionCount,
            progressPercent: progressPercent,
          ),
        ],
      ),
    );
  }
}
