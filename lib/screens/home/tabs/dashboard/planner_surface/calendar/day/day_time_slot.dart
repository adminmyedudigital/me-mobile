import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/dashboard_controller.dart';

class DayTimeSlot extends StatelessWidget {
  const DayTimeSlot({
    super.key,
    required this.date,
    required this.hour,
    required this.events,
    required this.onTap,
  });

  final DateTime date;
  final int hour;
  final List<DashboardEvent> events;
  final VoidCallback onTap;

  Color? progressBorderColor({
    required AppColors colors,
    required List<DashboardEvent> events,
    required DateTime date,
  }) {
    if (events.isEmpty) return null;

    final today = DashboardDateUtils.dateOnly(DateTime.now());
    final slotDate = DashboardDateUtils.dateOnly(date);
    if (slotDate.isAfter(today)) return null;

    final progress =
        events.fold<int>(
          0,
          (total, event) => total + event.progress.clamp(0, 100),
        ) /
        events.length;

    if (progress <= 33) return colors.accentRed;
    if (progress <= 75) return colors.accentBlue;
    return colors.accentGreen;
  }

  @override
  Widget build(BuildContext context) {
    final hasEvents = events.isNotEmpty;
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final statusBorderColor = progressBorderColor(
      colors: colors,
      events: events,
      date: date,
    );

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
                        ? colors.surfaceDeep
                        : colors.surfaceDeep,
                    borderRadius: AppRadius.button,
                    border: Border.all(
                      color:
                          statusBorderColor ??
                          (hasEvents
                              ? colors.primary.withValues(
                                  alpha: isLightTheme ? 0.16 : 0.22,
                                )
                              : isLightTheme
                              ? colors.hairline
                              : colors.hairlineStrong),
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
