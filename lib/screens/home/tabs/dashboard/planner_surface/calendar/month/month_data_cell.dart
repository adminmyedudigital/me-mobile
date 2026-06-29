import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/dashboard_controller.dart';

class MonthDateCell extends StatelessWidget {
  const MonthDateCell({
    super.key,
    required this.date,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.events,
    required this.onTap,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final List<DashboardEvent> events;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final color = isSelected
        ? isLightTheme
              ? colors.accentOrange.withValues(alpha: 0.16)
              : colors.accentOrange
        : isToday
        ? isLightTheme
              ? colors.surfaceElevated.withValues(alpha: 0.52)
              : colors.link.withValues(alpha: 0.2)
        : isCurrentMonth
        ? isLightTheme
              ? colors.surfaceElevated
              : colors.surfaceElevated.withValues(alpha: 0.58)
        : isLightTheme
        ? colors.surfaceElevated.withValues(alpha: 0.46)
        : colors.surfaceDeep.withValues(alpha: 0.72);
    final textColor = isSelected
        ? colors.primaryOn
        : isCurrentMonth
        ? isLightTheme
              ? colors.primary
              : colors.ink
        : colors.ash;
    final selectedTextColor = isLightTheme ? colors.primary : colors.primaryOn;
    final borderColor = isSelected
        ? colors.accentOrange.withValues(alpha: isLightTheme ? 0.62 : 0.5)
        : isToday
        ? colors.link.withValues(alpha: isLightTheme ? 0.34 : 0.48)
        : events.isNotEmpty
        ? colors.accentOrange.withValues(alpha: isLightTheme ? 0.24 : 0.34)
        : isLightTheme
        ? colors.hairline
        : colors.hairlineStrong;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.button,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadius.button,
            border: Border.all(color: borderColor),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: colors.accentOrangeGlow.withValues(
                    alpha: isLightTheme ? 0.2 : 0.28,
                  ),
                  blurRadius: isLightTheme ? 10 : 12,
                  offset: const Offset(0, 5),
                )
              else if (isLightTheme && isCurrentMonth)
                BoxShadow(
                  color: colors.canvas.withValues(alpha: 0.52),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${date.day}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isSelected ? selectedTextColor : textColor,
                    ),
                  ),
                  if (isToday) ...[
                    const SizedBox(width: AppSpacing.xxs),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? isLightTheme
                                  ? colors.accentOrange
                                  : colors.primary
                            : colors.link,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
              const Spacer(),
              if (events.isNotEmpty)
                Align(
                  alignment: Alignment.center,
                  child: MonthEventCountBadge(
                    count: events.length,
                    isSelected: isSelected,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
