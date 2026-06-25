import 'package:flutter/material.dart';
import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/screens/home/tabs/dashboard/planner_surface/date_navigation/date_navigation_container.dart';
import 'package:me_mobile/screens/home/tabs/dashboard/planner_surface/date_navigation/date_navigation_icon_button.dart';
import 'package:me_mobile/screens/home/tabs/dashboard/planner_surface/date_actions/date_action_button.dart';
import 'package:me_mobile/screens/home/tabs/dashboard/planner_surface/date_actions/date_action_container.dart';
import 'package:me_mobile/screens/home/tabs/dashboard/planner_surface/planner_surface_container.dart';
import 'package:me_mobile/screens/home/tabs/dashboard/planner_surface/view_switcher/view_switcher_button.dart';
import 'package:me_mobile/screens/home/tabs/dashboard/planner_surface/view_switcher/view_switcher_container.dart';
import 'package:me_mobile/theme/theme.dart';

part 'calendar/calendar_models.dart';
part 'calendar/calendar_detail_dialog.dart';
part 'calendar/calendar_views.dart';
part 'calendar/event_pill.dart';
part 'calendar/planner_surface.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  late DateTime _today;
  late DateTime _selectedDate;
  CalendarView _calendarView = CalendarView.day;

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const _weekdayNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static final _events = [
    _CalendarEvent(
      title: 'Mathematics practice',
      date: DateTime(2026, 6, 25),
      startHour: 9,
      durationHours: 1.5,
      colorKind: _EventColor.green,
    ),
    _CalendarEvent(
      title: 'Science revision',
      date: DateTime(2026, 6, 25),
      startHour: 13,
      durationHours: 1,
      colorKind: _EventColor.blue,
    ),
    _CalendarEvent(
      title: 'Mock exam',
      date: DateTime(2026, 6, 27),
      startHour: 10,
      durationHours: 2,
      colorKind: _EventColor.orange,
    ),
    _CalendarEvent(
      title: 'Notes review',
      date: DateTime(2026, 6, 30),
      startHour: 16,
      durationHours: 1,
      colorKind: _EventColor.red,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _today = _dateOnly(DateTime.now());
    _selectedDate = _today;
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(_today.year - 2),
      lastDate: DateTime(_today.year + 2, 12, 31),
      builder: (context, child) {
        return Theme(
          data: context.theme.copyWith(
            colorScheme: context.colorScheme.copyWith(
              primary: context.colors.accentGreen,
              onPrimary: context.colors.primaryOn,
              surface: context.colors.surfaceCard,
              onSurface: context.colors.ink,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;
    _selectDate(pickedDate);
  }

  void _selectDate(DateTime date) {
    setState(() => _selectedDate = _dateOnly(date));
  }

  void _changeView(CalendarView view) {
    setState(() => _calendarView = view);
  }

  void _moveDate(int direction) {
    setState(() {
      _selectedDate = switch (_calendarView) {
        CalendarView.month => DateTime(
          _selectedDate.year,
          _selectedDate.month + direction,
          1,
        ),
        CalendarView.week => _selectedDate.add(Duration(days: direction * 7)),
        CalendarView.day => _selectedDate.add(Duration(days: direction)),
      };
      _selectedDate = _dateOnly(_selectedDate);
    });
  }

  void _goToToday() {
    _today = _dateOnly(DateTime.now());
    _selectDate(_today);
  }

  String get _title {
    final month = _monthNames[_selectedDate.month - 1];
    final weekStart = _startOfWeek(_selectedDate);
    final weekEnd = weekStart.add(const Duration(days: 6));

    return switch (_calendarView) {
      CalendarView.month => '$month ${_selectedDate.year}',
      CalendarView.week =>
        '${_shortDate(weekStart)} - ${_shortDate(weekEnd)}, ${weekEnd.year}',
      CalendarView.day =>
        '${_weekdayName(_selectedDate)}, ${_selectedDate.day} $month',
    };
  }

  @override
  Widget build(BuildContext context) {
    return _PlannerSurface(
      title: _title,
      selectedDate: _selectedDate,
      today: _today,
      calendarView: _calendarView,
      events: _events,
      onPrevious: () => _moveDate(-1),
      onNext: () => _moveDate(1),
      onToday: _goToToday,
      onPickDate: _pickDate,
      onViewChanged: _changeView,
      onDateSelected: _selectDate,
    );
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime _startOfWeek(DateTime date) {
    final dateOnly = _dateOnly(date);
    return dateOnly.subtract(Duration(days: dateOnly.weekday - 1));
  }

  static bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  static String _weekdayName(DateTime date) {
    return [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ][date.weekday - 1];
  }

  static String _shortDate(DateTime date) {
    return '${date.day} ${_monthNames[date.month - 1].substring(0, 3)}';
  }
}
