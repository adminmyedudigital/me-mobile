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
    final badgeColor = colors.primary;
    final backgroundColor = isLightTheme
        ? badgeColor.withValues(alpha: 0.04)
        : badgeColor.withValues(alpha: 0.1);
    final borderColor = badgeColor.withValues(
      alpha: isSelected
          ? isLightTheme
                ? 0.28
                : 0.36
          : isLightTheme
          ? 0.12
          : 0.22,
    );
    final shadowColor = badgeColor.withValues(alpha: isLightTheme ? 0.06 : 0.1);
    final textColor = isLightTheme ? colors.primary : colors.ink;

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
                  color: badgeColor,
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
