import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.label,
    required this.percent,
    required this.color,
  });

  final String label;
  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final progress = percent.clamp(0, 100) / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: context.textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text('$percent%', style: context.textTheme.labelMedium),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: AppRadius.pill,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: context.colors.hairlineStrong,
            color: color,
          ),
        ),
      ],
    );
  }
}
