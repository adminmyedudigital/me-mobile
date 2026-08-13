import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class TopicEmptyState extends StatelessWidget {
  const TopicEmptyState({
    required this.colors,
    required this.icon,
    required this.title,
    required this.message,
    super.key,
  });

  final AppColors colors;
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: AppRadius.card,
        border: Border.all(color: colors.hairlineStrong),
      ),
      child: Column(
        children: [
          Icon(icon, color: colors.mute, size: 32),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
