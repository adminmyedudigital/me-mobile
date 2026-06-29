import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class QuizCardHeader extends StatelessWidget {
  const QuizCardHeader({
    super.key,
    required this.questionCount,
    required this.showHintDialog,
    required this.currentQuestionIndex,
  });

  final int questionCount;
  final int currentQuestionIndex;
  final VoidCallback showHintDialog;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Text(
            'Question ${currentQuestionIndex + 1} / $questionCount',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: colors.charcoal),
          ),
        ),
        IconButton(
          tooltip: 'Hint',
          onPressed: showHintDialog,
          icon: const Icon(Icons.lightbulb_outline_rounded),
        ),
      ],
    );
  }
}
