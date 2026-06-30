import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class ExamsTabMetric extends StatelessWidget {
  const ExamsTabMetric({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: AppSpacing.xxs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: context.colors.ink),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
