import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/routes/app_routes.dart';
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

  void openDayTimetable({
    required DateTime selectedDate,
    required int hour,
    required List<DashboardEvent> selectedEvents,
  }) {
    Get.find<DashboardController>().selectTimetableSlot(
      date: selectedDate,
      hour: hour,
      events: selectedEvents,
    );
    Get.toNamed(AppRoutes.dayTimetable);
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
            color: context.colors.primary,
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

                      return DayTimeSlot(
                        date: selectedDate,
                        hour: hour,
                        events: slotEvents,
                        onTap: () => openDayTimetable(
                          selectedDate: selectedDate,
                          hour: hour,
                          selectedEvents: slotEvents,
                        ),
                      );
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
