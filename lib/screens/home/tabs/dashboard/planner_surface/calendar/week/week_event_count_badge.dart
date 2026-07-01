import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class WeekEventCountBadge extends StatelessWidget {
  const WeekEventCountBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final badgeColor = colors.primary;
    final backgroundColor = isLightTheme
        ? badgeColor.withValues(alpha: 0.04)
        : badgeColor.withValues(alpha: 0.1);
    final borderColor = badgeColor.withValues(
      alpha: isLightTheme ? 0.12 : 0.22,
    );
    final shadowColor = badgeColor.withValues(alpha: isLightTheme ? 0.06 : 0.1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 34;
        final horizontalPadding = isCompact ? AppSpacing.xs : AppSpacing.sm;
        final dotSize = isCompact ? 5.0 : 6.0;

        return SizedBox(
          height: 35,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 52),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
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
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        color: badgeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: isCompact ? AppSpacing.xxs : AppSpacing.xs),
                    Text(
                      '$count',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isLightTheme ? colors.primary : colors.ink,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
