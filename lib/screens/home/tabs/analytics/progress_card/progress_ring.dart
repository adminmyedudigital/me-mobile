import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.label,
    required this.percent,
    required this.color,
    this.size = 88,
    this.strokeWidth = 7,
  });

  final String label;
  final int percent;
  final Color color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final progress = percent.clamp(0, 100) / 100;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withAlpha(18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              backgroundColor: context.colors.hairlineStrong,
              color: color,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$percent%',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  label,
                  style: context.textTheme.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
