import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/controllers/topic_understanding/topic_understanding.dart';
import 'package:me_mobile/screens/study/topic_understanding/progress_step_button.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_progress_indicator.dart';

class ProgressSliderControls extends StatelessWidget {
  const ProgressSliderControls({
    required this.controller,
    required this.colors,
    super.key,
  });

  final TopicUnderstandingProgressController controller;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final progress = controller.editingProgress;
    final color = topicProgressColor(progress, colors);

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: colors.hairlineStrong,
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.16),
            trackHeight: 8,
          ),
          child: Slider(
            value: progress.toDouble(),
            min: 0,
            max: 100,
            divisions: 100,
            label: '$progress%',
            onChanged: controller.setEditingProgress,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressStepButton(
              icon: Icons.remove_rounded,
              tooltip: 'Decrease by 5%',
              onPressed: progress == 0
                  ? null
                  : () => controller.adjustEditingProgress(-5),
            ),
            const SizedBox(width: AppSpacing.xl),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Text(
                '$progress%',
                key: ValueKey(progress),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xl),
            ProgressStepButton(
              icon: Icons.add_rounded,
              tooltip: 'Increase by 5%',
              onPressed: progress == 100
                  ? null
                  : () => controller.adjustEditingProgress(5),
            ),
          ],
        ),
      ],
    );
  }
}
