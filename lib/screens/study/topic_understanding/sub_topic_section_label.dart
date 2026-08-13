import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class SubTopicSectionLabel extends StatelessWidget {
  const SubTopicSectionLabel({required this.colors, super.key});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.account_tree_outlined, size: 16, color: colors.mute),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'SUB TOPICS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.mute,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
