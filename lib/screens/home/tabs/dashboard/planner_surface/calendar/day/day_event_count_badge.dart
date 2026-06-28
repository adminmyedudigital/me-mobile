import 'package:flutter/material.dart';

import 'package:me_mobile/controllers/dashboard_controller.dart';
import 'package:me_mobile/theme/theme.dart';

class DayEventCountBadge extends StatelessWidget {
  const DayEventCountBadge({super.key, required this.event});

  final DashboardEvent event;

  Color _eventColor(AppColors colors) {
    return switch (event.colorKind) {
      DashboardEventColor.green => colors.accentGreen,
      DashboardEventColor.blue => colors.accentBlue,
      DashboardEventColor.orange => colors.accentOrange,
      DashboardEventColor.red => colors.accentRed,
    };
  }

  Color _eventGlowColor(AppColors colors) {
    return switch (event.colorKind) {
      DashboardEventColor.green => colors.accentGreenGlow,
      DashboardEventColor.blue => colors.accentBlueGlow,
      DashboardEventColor.orange => colors.accentOrangeGlow,
      DashboardEventColor.red => colors.accentRedGlow,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final eventColor = _eventColor(colors);
    final eventGlowColor = _eventGlowColor(colors);
    final backgroundColor = isLightTheme
        ? eventColor.withValues(alpha: 0.1)
        : eventColor.withValues(alpha: 0.16);
    final borderColor = eventColor.withValues(
      alpha: isLightTheme ? 0.34 : 0.42,
    );
    final shadowColor = eventGlowColor.withValues(
      alpha: isLightTheme ? 0.12 : 0.22,
    );
    final titleColor = isLightTheme ? colors.primary : colors.ink;
    final timeColor = isLightTheme ? colors.charcoal : colors.body;

    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
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
        children: [
          Container(
            width: 4,
            height: 34,
            decoration: BoxDecoration(
              color: eventColor,
              borderRadius: AppRadius.pill,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  event.timeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: timeColor,
                    fontWeight: FontWeight.w700,
                    height: 1,
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
