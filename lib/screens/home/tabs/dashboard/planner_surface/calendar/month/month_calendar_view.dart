import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/controllers/dashboard_controller.dart';

class MonthCalendarView extends StatelessWidget {
  const MonthCalendarView({
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

  List<DashboardEvent> eventsForDay(
    List<DashboardEvent> events,
    DateTime date,
  ) {
    return events
        .where((event) => DashboardDateUtils.isSameDate(event.date, date))
        .toList()
      ..sort((first, second) => first.startHour.compareTo(second.startHour));
  }

  void openDayTimetable({
    required DateTime selectedDate,
    required List<DashboardEvent> selectedEvents,
  }) {
    final initialHour = selectedEvents.isEmpty
        ? DateTime.now().hour
        : selectedEvents.first.startHour.floor();

    Get.find<DashboardController>().selectTimetableSlot(
      date: selectedDate,
      hour: initialHour,
      events: selectedEvents,
    );
    Get.toNamed(AppRoutes.dayTimetable);
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final monthStart = DateTime(selectedDate.year, selectedDate.month);
    final gridStart = DashboardDateUtils.startOfWeek(monthStart);

    return Column(
      children: [
        WeekNameHeader(isLightTheme: isLightTheme),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            itemCount: 42,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 78,
              mainAxisSpacing: AppSpacing.xs,
              crossAxisSpacing: AppSpacing.xs,
            ),
            itemBuilder: (context, index) {
              final date = gridStart.add(Duration(days: index));
              final dayEvents = eventsForDay(events, date);

              return MonthDateCell(
                date: date,
                isCurrentMonth: date.month == selectedDate.month,
                isSelected: DashboardDateUtils.isSameDate(date, selectedDate),
                isToday: DashboardDateUtils.isSameDate(date, today),
                events: dayEvents,
                onTap: () {
                  onDateSelected(date);
                  openDayTimetable(
                    selectedDate: date,
                    selectedEvents: dayEvents,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
