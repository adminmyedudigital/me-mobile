part of '../dashboard_tab.dart';

enum _EventColor { green, blue, orange, red }

class _CalendarEvent {
  const _CalendarEvent({
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
  final _EventColor colorKind;

  String get timeLabel =>
      '${_hourLabel(startHour.floor())}'
      ' - ${_hourLabel((startHour + durationHours).floor())}';

  Color color(BuildContext context) {
    return switch (colorKind) {
      _EventColor.green => context.colors.accentGreen,
      _EventColor.blue => context.colors.accentBlue,
      _EventColor.orange => context.colors.accentOrange,
      _EventColor.red => context.colors.accentRed,
    };
  }
}

List<_CalendarEvent> _eventsForDay(List<_CalendarEvent> events, DateTime date) {
  return events
      .where((event) => _DashboardTabState._isSameDate(event.date, date))
      .toList()
    ..sort((first, second) => first.startHour.compareTo(second.startHour));
}

_CalendarEvent? _eventForSlot(
  List<_CalendarEvent> events,
  DateTime date,
  int hour,
) {
  for (final event in _eventsForDay(events, date)) {
    if (event.startHour.floor() == hour) return event;
  }
  return null;
}

String _hourLabel(int hour) {
  final normalizedHour = hour % 24;
  final period = normalizedHour >= 12 ? 'PM' : 'AM';
  final displayHour = normalizedHour % 12 == 0 ? 12 : normalizedHour % 12;
  return '$displayHour $period';
}
