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

    return eventsForDay(
      events,
      date,
    ).where((event) => eventOverlapsSlot(event, hour, nextHour)).toList();
  }

  bool eventOverlapsSlot(DashboardEvent event, int slotStart, int slotEnd) {
    final normalizedSlotStart = slotStart == 24
        ? 24.0
        : (slotStart % 24).toDouble();
    var normalizedSlotEnd = slotEnd == 24 ? 24.0 : (slotEnd % 24).toDouble();

    if (normalizedSlotEnd <= normalizedSlotStart) {
      normalizedSlotEnd += 24;
    }

    var eventStart = event.startHour == 24 ? 24.0 : event.startHour % 24;

    if (eventStart < normalizedSlotStart &&
        normalizedSlotStart >= 24 &&
        eventStart < normalizedSlotEnd % 24) {
      eventStart += 24;
    }

    final eventEnd = eventStart + event.durationHours;

    return eventStart < normalizedSlotEnd && eventEnd > normalizedSlotStart;
  }

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
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Row(
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
              final statusBorderColor = progressBorderColor(
                colors: colors,
                events: slotEvents,
                date: day,
              );

              return Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: AppSpacing.xs),
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
                          color:
                              statusBorderColor ??
                              (slotEvents.isEmpty
                                  ? isLightTheme
                                        ? colors.hairline
                                        : colors.hairlineStrong
                                  : colors.accentOrange.withValues(
                                      alpha: isLightTheme ? 0.22 : 0.36,
                                    )),
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
                ),
              );
            },
          ),
      ],
    );
  }
}
