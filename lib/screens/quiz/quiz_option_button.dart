import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/enums/quiz_enums.dart';

class QuizOptionButton extends StatelessWidget {
  const QuizOptionButton({
    super.key,
    required this.index,
    required this.label,
    required this.answerState,
    required this.onTap,
  });

  final int index;
  final String label;
  final QuizAnswerState answerState;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final backgroundColor = answerState == QuizAnswerState.correct
        ? colors.accentGreenGlow
        : answerState == QuizAnswerState.wrong
        ? colors.accentRedGlow
        : answerState == QuizAnswerState.selected
        ? colors.accentOrangeGlow
        : colors.surfaceDeep;
    final borderColor = answerState == QuizAnswerState.correct
        ? colors.accentGreen
        : answerState == QuizAnswerState.wrong
        ? colors.accentRed
        : answerState == QuizAnswerState.selected
        ? colors.accentOrange
        : colors.hairlineStrong;
    final icon = answerState == QuizAnswerState.correct
        ? Icons.check_circle_rounded
        : answerState == QuizAnswerState.wrong
        ? Icons.cancel_rounded
        : Icons.radio_button_unchecked_rounded;

    return InkWell(
      borderRadius: AppRadius.button,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 54),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppRadius.button,
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                String.fromCharCode(65 + index),
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: colors.ink),
              ),
            ),
            Expanded(
              child: Text(
                label,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colors.ink),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(icon, color: borderColor, size: 20),
          ],
        ),
      ),
    );
  }
}
