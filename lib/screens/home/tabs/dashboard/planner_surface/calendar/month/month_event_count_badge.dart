import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class MonthEventCountBadge extends StatelessWidget {
  const MonthEventCountBadge({
    super.key,
    required this.count,
    this.isSelected = false,
  });

  final int count;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final contrastColor = colors.primary;
    final backgroundColor = isLightTheme
        ? colors.accentOrange.withValues(alpha: 0.1)
        : colors.accentOrange.withValues(alpha: 0.16);
    final borderColor = isSelected
        ? contrastColor
        : colors.accentOrange.withValues(alpha: isLightTheme ? 0.34 : 0.45);
    final shadowColor = colors.accentOrangeGlow.withValues(
      alpha: isLightTheme ? 0.12 : 0.28,
    );
    final textColor = isLightTheme ? colors.primary : colors.ink;
    final dotColor = isSelected ? contrastColor : colors.accentOrange;

    return SizedBox(
      height: 35,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(minWidth: 30, maxWidth: 52),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: AppRadius.pill,
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '$count',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
