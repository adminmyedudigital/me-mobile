import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/controllers/dashboard_controller.dart';

class WeekCalendarView extends StatefulWidget {
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
  State<WeekCalendarView> createState() => _WeekCalendarViewState();
}

class _WeekCalendarViewState extends State<WeekCalendarView> {
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
  void didUpdateWidget(covariant WeekCalendarView oldWidget) {
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
    final weekStart = DashboardDateUtils.startOfWeek(widget.selectedDate);
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
                      widget.selectedDate,
                    ),
                    isToday: DashboardDateUtils.isSameDate(date, widget.today),
                    onTap: () {
                      widget.onDateSelected(date);
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
                for (final hour in DashboardDateUtils.calendarHourSlots)
                  WeekTimeRow(
                    key: hour == _currentHour ? _currentHourKey : null,
                    hour: hour,
                    days: days,
                    events: widget.events,
                    onDateSelected: widget.onDateSelected,
                    onSlotSelected: openDayTimetable,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
