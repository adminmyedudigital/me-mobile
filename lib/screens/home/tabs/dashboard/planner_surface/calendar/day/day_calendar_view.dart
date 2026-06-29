import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/dashboard_controller.dart';

class DayCalendarView extends StatefulWidget {
  const DayCalendarView({
    super.key,
    required this.selectedDate,
    required this.events,
  });

  final DateTime selectedDate;
  final List<DashboardEvent> events;

  @override
  State<DayCalendarView> createState() => _DayCalendarViewState();
}

class _DayCalendarViewState extends State<DayCalendarView> {
  final GlobalKey _currentHourKey = GlobalKey();
  late int _currentHour;
  Timer? _currentHourTimer;

  @override
  void initState() {
    super.initState();
    _currentHour = DateTime.now().hour;
    _currentHourTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      final currentHour = DateTime.now().hour;
      if (currentHour == _currentHour) return;
      if (!mounted) return;

      setState(() {
        _currentHour = currentHour;
      });
      _centerCurrentHour();
    });
    _centerCurrentHour();
  }

  @override
  void dispose() {
    _currentHourTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DayCalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _centerCurrentHour();
  }

  void _centerCurrentHour() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final currentHourContext = _currentHourKey.currentContext;
      if (currentHourContext == null) return;

      Scrollable.ensureVisible(
        currentHourContext,
        alignment: 0.5,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    });
  }

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
    final dayEvents = eventsForDay(widget.events, widget.selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${DashboardDateUtils.weekdayName(widget.selectedDate)}, ${widget.selectedDate.day}',
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
                for (final hour in DashboardDateUtils.calendarHourSlots)
                  Builder(
                    builder: (context) {
                      final slotEvents = eventsForHour(dayEvents, hour);

                      return DayTimeSlot(
                        key: hour == _currentHour ? _currentHourKey : null,
                        date: widget.selectedDate,
                        hour: hour,
                        events: slotEvents,
                        onTap: () => openDayTimetable(
                          selectedDate: widget.selectedDate,
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
