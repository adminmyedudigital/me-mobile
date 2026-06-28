import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/dashboard_controller.dart';

class WeekCalendarView extends StatelessWidget {
  const WeekCalendarView({
    super.key,
    required this.selectedDate,
    required this.today,
    required this.events,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final DateTime today;
  final List<DashboardEvent> events;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final weekStart = DashboardDateUtils.startOfWeek(selectedDate);
    final days = List.generate(
      7,
      (index) => weekStart.add(Duration(days: index)),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            children: [
              SizedBox(height: 60, width: 40),
              for (final date in days)
                Expanded(
                  child: WeekDayHeader(
                    date: date,
                    isSelected: DashboardDateUtils.isSameDate(
                      date,
                      selectedDate,
                    ),
                    isToday: DashboardDateUtils.isSameDate(date, today),
                    onTap: () {
                      onDateSelected(date);
                      // _showCalendarDetailsDialog(
                      //   context: context,
                      //   date: date,
                      //   events: _eventsForDay(events, date),
                      // );
                    },
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: AppSpacing.xs,
              bottom: AppSpacing.band,
            ),
            child: Column(
              children: [
                for (final hour in DashboardDateUtils.weekdayTime)
                  WeekTimeRow(
                    hour: hour,
                    days: days,
                    events: events,
                    onDateSelected: onDateSelected,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
