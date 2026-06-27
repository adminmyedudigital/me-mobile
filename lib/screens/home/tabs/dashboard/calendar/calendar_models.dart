part of '../dashboard_tab.dart';

extension _DashboardEventPresentation on DashboardEvent {
  Color color(BuildContext context) {
    return switch (colorKind) {
      DashboardEventColor.green => context.colors.accentGreen,
      DashboardEventColor.blue => context.colors.accentBlue,
      DashboardEventColor.orange => context.colors.accentOrange,
      DashboardEventColor.red => context.colors.accentRed,
    };
  }
}

List<DashboardEvent> _eventsForDay(List<DashboardEvent> events, DateTime date) {
  return events
      .where((event) => DashboardDateUtils.isSameDate(event.date, date))
      .toList()
    ..sort((first, second) => first.startHour.compareTo(second.startHour));
}

DashboardEvent? _eventForSlot(
  List<DashboardEvent> events,
  DateTime date,
  int hour,
) {
  for (final event in _eventsForDay(events, date)) {
    if (event.startHour.floor() == hour) return event;
  }
  return null;
}
