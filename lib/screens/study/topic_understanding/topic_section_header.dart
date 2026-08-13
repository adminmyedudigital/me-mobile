import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class TopicSectionHeader extends StatelessWidget {
  const TopicSectionHeader({
    required this.topicCount,
    required this.colors,
    super.key,
  });

  final int topicCount;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.topic_outlined, color: colors.accentBlue, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Text('Topics', style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        Text(
          '$topicCount available',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
