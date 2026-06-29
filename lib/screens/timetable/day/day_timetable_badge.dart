import 'package:flutter/material.dart';

import 'package:me_mobile/controllers/dashboard_controller.dart';
import 'package:me_mobile/theme/theme.dart';

class DayTimeTableBadge extends StatelessWidget {
  const DayTimeTableBadge({
    super.key,
    required this.event,
    required this.isExpanded,
    required this.onTap,
  });

  final DashboardEvent event;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final eventColor = colors.primary;
    final eventGlowColor = colors.primaryOn;
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        onTap: onTap,
        child: Container(
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
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: eventColor,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
