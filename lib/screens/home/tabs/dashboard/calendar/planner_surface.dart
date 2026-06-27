part of '../dashboard_tab.dart';

class _PlannerSurface extends StatelessWidget {
  const _PlannerSurface({
    required this.title,
    required this.selectedDate,
    required this.today,
    required this.calendarView,
    required this.events,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
    required this.onPickDate,
    required this.onViewChanged,
    required this.onDateSelected,
  });

  final String title;
  final DateTime selectedDate;
  final DateTime today;
  final CalendarView calendarView;
  final List<DashboardEvent> events;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final VoidCallback onPickDate;
  final ValueChanged<CalendarView> onViewChanged;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlannerSurfaceContainer(
            title: title,
            calendarView: calendarView,
            onPrevious: onPrevious,
            onNext: onNext,
            onToday: onToday,
            onPickDate: onPickDate,
            onViewChanged: onViewChanged,
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: SingleChildScrollView(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: switch (calendarView) {
                  CalendarView.month => _MonthCalendarView(
                    key: const ValueKey(CalendarView.month),
                    selectedDate: selectedDate,
                    today: today,
                    events: events,
                    onDateSelected: onDateSelected,
                  ),
                  CalendarView.week => _WeekCalendarView(
                    key: const ValueKey(CalendarView.week),
                    selectedDate: selectedDate,
                    today: today,
                    events: events,
                    onDateSelected: onDateSelected,
                  ),
                  CalendarView.day => _DayCalendarView(
                    key: const ValueKey(CalendarView.day),
                    selectedDate: selectedDate,
                    events: events,
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
