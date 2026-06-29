import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/screens/screens.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({
    super.key,
    required this.question,
    required this.currentQuestionIndex,
    required this.questionCount,
    required this.showHintDialog,
    required this.answerStateForOption,
    required this.onOptionSelected,
    this.selectedOptionIndex,
  });

  final QuizData question;
  final int currentQuestionIndex;
  final int questionCount;
  final VoidCallback showHintDialog;
  final QuizAnswerState Function(int) answerStateForOption;
  final void Function(int) onOptionSelected;
  final int? selectedOptionIndex;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.60,
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
          QuizCardHeader(
            currentQuestionIndex: currentQuestionIndex,
            questionCount: questionCount,
            showHintDialog: showHintDialog,
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: colors.primary),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  for (final option in question.options.indexed) ...[
                    QuizOptionButton(
                      index: option.$1,
                      label: option.$2,
                      answerState: answerStateForOption(option.$1),
                      onTap: selectedOptionIndex == null
                          ? () => onOptionSelected(option.$1)
                          : null,
                    ),
                    if (option.$1 != question.options.length - 1)
                      const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
