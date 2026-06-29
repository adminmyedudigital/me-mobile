import 'package:flutter/material.dart';

class QuizNavigationButton extends StatelessWidget {
  const QuizNavigationButton({
    super.key,
    required this.onNextPressed,
    required this.onPreviousPressed,
    required this.canGoNext,
    required this.canGoPrevious,
  });

  final VoidCallback onNextPressed;
  final VoidCallback onPreviousPressed;
  final bool canGoNext;
  final bool canGoPrevious;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          tooltip: 'Previous',
          onPressed: canGoPrevious ? onPreviousPressed : null,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(flex: 1, child: Container()),
        IconButton.filledTonal(
          tooltip: 'Next',
          onPressed: canGoNext ? onNextPressed : null,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}
