import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class FlashCardResultHeader extends StatelessWidget {
  const FlashCardResultHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flashcard result',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: colors.charcoal),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Here is how this review round went.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colors.body),
        ),
      ],
    );
  }
}
