import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class WeekEventCountBadge extends StatelessWidget {
  const WeekEventCountBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final backgroundColor = isLightTheme
        ? colors.accentOrange.withValues(alpha: 0.1)
        : colors.accentOrange.withValues(alpha: 0.16);
    final borderColor = colors.accentOrange.withValues(
      alpha: isLightTheme ? 0.34 : 0.45,
    );
    final shadowColor = colors.accentOrangeGlow.withValues(
      alpha: isLightTheme ? 0.12 : 0.28,
    );

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
                  color: colors.accentOrange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '$count',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isLightTheme ? colors.primary : colors.ink,
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
