import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/dashboard_controller.dart';

class DayTimeSlot extends StatelessWidget {
  const DayTimeSlot({
    super.key,
    required this.hour,
    required this.events,
    required this.onTap,
  });

  final int hour;
  final List<DashboardEvent> events;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasEvents = events.isNotEmpty;
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Container(
      constraints: BoxConstraints(minHeight: hasEvents ? 74 : 54),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 54,
            child: Text(
              DashboardDateUtils.hourLabel(hour),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isLightTheme ? colors.mute : colors.ash,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: AppRadius.button,
                onTap: onTap,
                child: Container(
                  constraints: BoxConstraints(minHeight: hasEvents ? 58 : 54),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isLightTheme
                        ? colors.surfaceCard
                        : colors.surfaceDeep,
                    borderRadius: AppRadius.button,
                    border: Border.all(
                      color: hasEvents
                          ? colors.primary.withValues(
                              alpha: isLightTheme ? 0.16 : 0.22,
                            )
                          : isLightTheme
                          ? colors.hairline
                          : colors.hairlineStrong,
                    ),
                    boxShadow: [
                      if (isLightTheme)
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: !hasEvents
                      ? const SizedBox.shrink()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final event in events) ...[
                              DayEventCountBadge(event: event),
                              if (event != events.last)
                                const SizedBox(height: AppSpacing.xs),
                            ],
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
