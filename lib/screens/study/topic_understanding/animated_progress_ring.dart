import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_progress_indicator.dart';

class AnimatedProgressRing extends StatelessWidget {
  const AnimatedProgressRing({
    required this.progress,
    required this.colors,
    super.key,
  });

  final int progress;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: progress.toDouble()),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (context, animatedProgress, child) {
        final roundedProgress = animatedProgress.round();
        final color = topicProgressColor(roundedProgress, colors);

        return SizedBox.square(
          dimension: 190,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.square(
                dimension: 174,
                child: CircularProgressIndicator(
                  value: animatedProgress / 100,
                  strokeWidth: 14,
                  strokeCap: StrokeCap.round,
                  color: color,
                  backgroundColor: colors.hairlineStrong,
                ),
              ),
              Text(
                '$roundedProgress%',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
