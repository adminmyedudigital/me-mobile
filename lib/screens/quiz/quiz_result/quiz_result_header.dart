import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class QuizResultHeader extends StatelessWidget {
  const QuizResultHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quiz result',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.charcoal,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Here is how this practice round went.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colors.body),
        ),
      ],
    );
  }
}
