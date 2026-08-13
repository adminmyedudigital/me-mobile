import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class TopicProgressIndicator extends StatelessWidget {
  const TopicProgressIndicator({
    required this.progress,
    required this.colors,
    this.dimension = 38,
    super.key,
  });

  final int progress;
  final AppColors colors;
  final double dimension;

  @override
  Widget build(BuildContext context) {
    final progressColor = topicProgressColor(progress, colors);

    return SizedBox.square(
      dimension: dimension,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.square(
            dimension: dimension - 4,
            child: CircularProgressIndicator(
              value: progress / 100,
              strokeWidth: 3,
              strokeCap: StrokeCap.round,
              color: progressColor,
              backgroundColor: colors.hairlineStrong,
            ),
          ),
          Text(
            '$progress%',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: progressColor,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

Color topicProgressColor(int progress, AppColors colors) {
  if (progress == 0) return colors.mute;
  if (progress < 40) return colors.accentRed;
  if (progress < 70) return colors.accentOrange;
  return colors.accentGreen;
}
