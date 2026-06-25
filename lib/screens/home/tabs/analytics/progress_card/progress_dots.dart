import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class ProgressDots extends StatelessWidget {
  const ProgressDots({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.color,
  });

  final int count;
  final int currentIndex;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < count; index++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: index == currentIndex ? 20 : 6,
            height: 6,
            margin: const EdgeInsets.only(left: AppSpacing.xs),
            decoration: BoxDecoration(
              color: index == currentIndex
                  ? color
                  : context.colors.hairlineStrong,
              borderRadius: AppRadius.pill,
            ),
          ),
      ],
    );
  }
}
