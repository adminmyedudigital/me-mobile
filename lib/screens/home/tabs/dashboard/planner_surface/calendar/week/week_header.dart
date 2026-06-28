import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/controllers/dashboard_controller.dart';

class WeekDayHeader extends StatelessWidget {
  const WeekDayHeader({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final color = isSelected
        ? colors.accentOrange
        : isToday
        ? isLightTheme
              ? colors.accentBlueGlow.withValues(alpha: 0.55)
              : colors.link.withValues(alpha: 0.22)
        : isLightTheme
        ? colors.surfaceElevated
        : colors.surfaceElevated;
    final textColor = isSelected
        ? colors.primaryOn
        : isLightTheme
        ? colors.primary
        : colors.ink;
    final borderColor = isSelected
        ? colors.accentOrange.withValues(alpha: 0.5)
        : isToday
        ? colors.link.withValues(alpha: isLightTheme ? 0.36 : 0.48)
        : isLightTheme
        ? colors.hairline
        : colors.hairlineStrong;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      child: InkWell(
        borderRadius: AppRadius.button,
        onTap: onTap,
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadius.button,
            border: Border.all(color: borderColor),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: colors.accentOrangeGlow.withValues(alpha: 0.34),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                )
              else if (isToday)
                BoxShadow(
                  color: colors.accentBlueGlow.withValues(
                    alpha: isLightTheme ? 0.14 : 0.2,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                )
              else if (isLightTheme)
                BoxShadow(
                  color: colors.canvas.withValues(alpha: 0.7),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DashboardDateUtils.weekdayNames[date.weekday - 1],
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${date.day}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
