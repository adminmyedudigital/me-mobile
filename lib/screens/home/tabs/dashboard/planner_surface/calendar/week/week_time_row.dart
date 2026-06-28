import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/dashboard_controller.dart';

class WeekTimeRow extends StatelessWidget {
  const WeekTimeRow({
    super.key,
    required this.hour,
    required this.days,
    required this.events,
    required this.onDateSelected,
  });

  final int hour;
  final List<DateTime> days;
  final List<DashboardEvent> events;
  final ValueChanged<DateTime> onDateSelected;

  List<DashboardEvent> eventsForDay(
    List<DashboardEvent> events,
    DateTime date,
  ) {
    return events
        .where((event) => DashboardDateUtils.isSameDate(event.date, date))
        .toList()
      ..sort((first, second) => first.startHour.compareTo(second.startHour));
  }

  List<DashboardEvent> eventsForSlot(
    List<DashboardEvent> events,
    DateTime date,
    int hour,
  ) {
    final nextHour = DashboardDateUtils.nextWeekdayTime(hour);

    return eventsForDay(events, date)
        .where(
          (event) =>
              DashboardDateUtils.isHourInSlot(event.startHour, hour, nextHour),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return SizedBox(
      height: 62,
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              DashboardDateUtils.hourLabel(hour),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isLightTheme ? colors.mute : colors.ash,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          for (final day in days)
            Builder(
              builder: (context) {
                final slotEvents = eventsForSlot(events, day, hour);

                return Expanded(
                  child: InkWell(
                    onTap: () {
                      onDateSelected(day);
                      // _showCalendarDetailsDialog(
                      //   context: context,
                      //   date: day,
                      //   events: _eventsForDay(events, day),
                      //   hour: hour,
                      // );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(AppSpacing.xxs),
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: isLightTheme
                            ? colors.surfaceElevated
                            : colors.surfaceElevated.withValues(alpha: 0.58),
                        borderRadius: AppRadius.button,
                        border: Border.all(
                          color: slotEvents.isEmpty
                              ? isLightTheme
                                    ? colors.hairline
                                    : colors.hairlineStrong
                              : colors.accentOrange.withValues(
                                  alpha: isLightTheme ? 0.22 : 0.36,
                                ),
                        ),
                        boxShadow: [
                          if (isLightTheme)
                            BoxShadow(
                              color: colors.canvas.withValues(alpha: 0.58),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          else if (slotEvents.isNotEmpty)
                            BoxShadow(
                              color: colors.accentOrangeGlow.withValues(
                                alpha: 0.18,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                        ],
                      ),
                      child: slotEvents.isEmpty
                          ? const SizedBox(height: 35)
                          : WeekEventCountBadge(count: slotEvents.length),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
