import 'package:get/get.dart';
import 'package:me_mobile/enums/enums.dart';

enum DashboardEventColor { green, blue, orange, red }

class DashboardEvent {
  const DashboardEvent({
    required this.title,
    required this.date,
    required this.startHour,
    required this.durationHours,
    required this.colorKind,
  });

  final String title;
  final DateTime date;
  final double startHour;
  final double durationHours;
  final DashboardEventColor colorKind;

  String get timeLabel =>
      '${DashboardDateUtils.timeLabel(startHour)}'
      ' - ${DashboardDateUtils.timeLabel(startHour + durationHours)}';
}

class DashboardDateUtils {
  const DashboardDateUtils._();

  static const monthNames = [
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

  static const weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static const weekdayTime = [
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    1,
    2,
    3,
    4,
    5,
  ];

  static int nextWeekdayTime(int hour) {
    final index = weekdayTime.indexOf(hour);
    if (index == -1 || index == weekdayTime.length - 1) {
      return hour + 2;
    }

    return weekdayTime[index + 1];
  }

  static bool isHourInSlot(double eventHour, int slotStart, int slotEnd) {
    final normalizedEventHour = eventHour == 24 ? 24.0 : eventHour % 24;
    final normalizedStart = slotStart == 24 ? 24 : slotStart % 24;
    final normalizedEnd = slotEnd == 24 ? 24 : slotEnd % 24;

    if (normalizedEnd > normalizedStart) {
      return normalizedEventHour >= normalizedStart &&
          normalizedEventHour < normalizedEnd;
    }

    return normalizedEventHour >= normalizedStart ||
        normalizedEventHour < normalizedEnd;
  }

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime startOfWeek(DateTime date) {
    final onlyDate = dateOnly(date);
    return onlyDate.subtract(Duration(days: onlyDate.weekday - 1));
  }

  static bool isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  static String weekdayName(DateTime date) {
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

  static String shortDate(DateTime date) {
    return '${date.day} ${monthNames[date.month - 1].substring(0, 3)}';
  }

  static String hourLabel(int hour) {
    final normalizedHour = hour % 24;
    final period = normalizedHour >= 12 ? 'PM' : 'AM';
    final displayHour = normalizedHour % 12 == 0 ? 12 : normalizedHour % 12;
    return '$displayHour $period';
  }

  static String timeLabel(double hour) {
    final totalMinutes = (hour * 60).round();
    final normalizedMinutes = totalMinutes % (24 * 60);
    final normalizedHour = normalizedMinutes ~/ 60;
    final minute = normalizedMinutes % 60;
    final period = normalizedHour >= 12 ? 'PM' : 'AM';
    final displayHour = normalizedHour % 12 == 0 ? 12 : normalizedHour % 12;

    if (minute == 0) {
      return '$displayHour $period';
    }

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
}

class DashboardController extends GetxController {
  final Rx<DateTime> today = DashboardDateUtils.dateOnly(DateTime.now()).obs;
  final Rx<DateTime> selectedDate = DashboardDateUtils.dateOnly(
    DateTime.now(),
  ).obs;
  final Rx<CalendarView> calendarView = CalendarView.day.obs;

  final List<DashboardEvent> events = [
    DashboardEvent(
      title: 'Mathematics practice',
      date: DateTime(2026, 6, 28),
      startHour: 13,
      durationHours: 1.5,
      colorKind: DashboardEventColor.green,
    ),
    DashboardEvent(
      title: 'Science revision',
      date: DateTime(2026, 6, 28),
      startHour: 13,
      durationHours: 1,
      colorKind: DashboardEventColor.blue,
    ),
    DashboardEvent(
      title: 'Mock exam',
      date: DateTime(2026, 6, 27),
      startHour: 10,
      durationHours: 2,
      colorKind: DashboardEventColor.orange,
    ),
    DashboardEvent(
      title: 'Notes review',
      date: DateTime(2026, 6, 30),
      startHour: 16,
      durationHours: 1,
      colorKind: DashboardEventColor.red,
    ),
  ];

  String get title {
    final date = selectedDate.value;
    final month = DashboardDateUtils.monthNames[date.month - 1];
    final weekStart = DashboardDateUtils.startOfWeek(date);
    final weekEnd = weekStart.add(const Duration(days: 6));

    return switch (calendarView.value) {
      CalendarView.month => '$month ${date.year}',
      CalendarView.week =>
        '${DashboardDateUtils.shortDate(weekStart)} - '
            '${DashboardDateUtils.shortDate(weekEnd)}, ${weekEnd.year}',
      CalendarView.day =>
        '${DashboardDateUtils.weekdayName(date)}, ${date.day} $month',
    };
  }

  void selectDate(DateTime date) {
    selectedDate.value = DashboardDateUtils.dateOnly(date);
  }

  void changeView(CalendarView view) {
    calendarView.value = view;
  }

  void moveDate(int direction) {
    final date = selectedDate.value;
    final nextDate = switch (calendarView.value) {
      CalendarView.month => DateTime(date.year, date.month + direction, 1),
      CalendarView.week => date.add(Duration(days: direction * 7)),
      CalendarView.day => date.add(Duration(days: direction)),
    };

    selectedDate.value = DashboardDateUtils.dateOnly(nextDate);
  }

  void goToToday() {
    today.value = DashboardDateUtils.dateOnly(DateTime.now());
    selectDate(today.value);
  }
}
