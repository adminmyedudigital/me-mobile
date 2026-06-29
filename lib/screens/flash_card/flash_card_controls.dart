import 'package:flutter/material.dart';

import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';

class FlashCardControls extends StatelessWidget {
  const FlashCardControls({
    super.key,
    required this.currentIndex,
    required this.cardCount,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.selectedFeedback,
    required this.onPrevious,
    required this.onNext,
    required this.onFeedbackSelected,
  });

  final int currentIndex;
  final int cardCount;
  final bool canGoPrevious;
  final bool canGoNext;
  final FlashCardFeedback? selectedFeedback;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<FlashCardFeedback> onFeedbackSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton.filledTonal(
          tooltip: 'Previous card',
          onPressed: canGoPrevious ? onPrevious : null,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(flex: 1, child: Container()),
        FlashCardFeedbackIconButton(
          icon: Icons.close_rounded,
          color: context.colors.accentRed,
          tooltip: 'Need review',
          isSelected: selectedFeedback == FlashCardFeedback.review,
          onTap: () => onFeedbackSelected(FlashCardFeedback.review),
        ),
        const SizedBox(width: AppSpacing.lg),
        FlashCardFeedbackIconButton(
          icon: Icons.check_rounded,
          color: context.colors.accentGreen,
          tooltip: 'Correct',
          isSelected: selectedFeedback == FlashCardFeedback.known,
          onTap: () => onFeedbackSelected(FlashCardFeedback.known),
        ),
        Expanded(flex: 1, child: Container()),
        IconButton.filledTonal(
          tooltip: 'Next card',
          onPressed: canGoNext ? onNext : null,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}
