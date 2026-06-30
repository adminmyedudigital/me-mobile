import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';

class FlashCardResultMetrics extends StatelessWidget {
  const FlashCardResultMetrics({
    super.key,
    required this.correctCount,
    required this.wrongCount,
    required this.skipCount,
  });

  final int correctCount;
  final int wrongCount;
  final int skipCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: FlashCardResultMetricCard(
            icon: Icons.check_circle_rounded,
            label: 'Correct',
            value: correctCount.toString(),
            color: colors.accentGreen,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: FlashCardResultMetricCard(
            icon: Icons.cancel_rounded,
            label: 'Wrong',
            value: wrongCount.toString(),
            color: colors.accentRed,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: FlashCardResultMetricCard(
            icon: Icons.skip_next_rounded,
            label: 'Skip',
            value: skipCount.toString(),
            color: colors.accentBlue,
          ),
        ),
      ],
    );
  }
}
