import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class DateActionButton extends StatelessWidget {
  const DateActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.button,
        onTap: onTap,
        child: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: context.colors.surfaceElevated,
            borderRadius: AppRadius.button,
            border: Border.all(color: context.colors.hairline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: context.colors.ink),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
