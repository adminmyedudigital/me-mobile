import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class ProgressEditorContextItem extends StatelessWidget {
  const ProgressEditorContextItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.colors,
    this.highlighted = false,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final AppColors colors;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final accentColor = highlighted ? colors.accentBlue : colors.mute;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: highlighted ? colors.accentBlueGlow : colors.surfaceCard,
        borderRadius: AppRadius.card,
        border: Border.all(
          color: highlighted ? colors.accentBlue : colors.hairlineStrong,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: highlighted ? colors.ink : colors.body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
