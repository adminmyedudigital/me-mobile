import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class QuizScoreRing extends StatelessWidget {
  const QuizScoreRing({super.key, required this.progressPercent});

  final double progressPercent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final progressValue = (progressPercent / 100).clamp(0.0, 1.0);

    return SizedBox(
      width: 164,
      height: 164,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progressValue,
              strokeWidth: 14,
              strokeCap: StrokeCap.round,
              backgroundColor: colors.surfaceDeep,
              color: colors.accentOrange,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${progressPercent.round()}%',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: colors.primary),
              ),
              Text(
                'score',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: colors.charcoal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
