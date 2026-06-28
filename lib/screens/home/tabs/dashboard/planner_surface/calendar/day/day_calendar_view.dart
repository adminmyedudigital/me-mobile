import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/dashboard_controller.dart';

class DayCalendarView extends StatelessWidget {
  const DayCalendarView({
    super.key,
    required this.selectedDate,
    required this.events,
  });

  final DateTime selectedDate;
  final List<DashboardEvent> events;

  List<DashboardEvent> eventsForDay(
    List<DashboardEvent> events,
    DateTime date,
  ) {
    return events
        .where((event) => DashboardDateUtils.isSameDate(event.date, date))
        .toList()
      ..sort((first, second) => first.startHour.compareTo(second.startHour));
  }

  List<DashboardEvent> eventsForHour(List<DashboardEvent> events, int hour) {
    final slotStart = hour.toDouble();
    final slotEnd = slotStart + 1;

    return events.where((event) {
      final eventStart = event.startHour;
      final eventEnd = event.startHour + event.durationHours;

      return eventStart < slotEnd && eventEnd > slotStart;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dayEvents = eventsForDay(events, selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${DashboardDateUtils.weekdayName(selectedDate)}, ${selectedDate.day}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.colors.accentOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: AppSpacing.xs,
              bottom: AppSpacing.band,
            ),
            child: Column(
              children: [
                for (final hour in List.generate(11, (index) => index + 8))
                  Builder(
                    builder: (context) {
                      final slotEvents = eventsForHour(dayEvents, hour);

                      return DayTimeSlot(hour: hour, events: slotEvents);
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
