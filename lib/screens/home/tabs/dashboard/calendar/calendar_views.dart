part of '../dashboard_tab.dart';

class _MonthCalendarView extends StatelessWidget {
  const _MonthCalendarView({
    super.key,
    required this.selectedDate,
    required this.today,
    required this.events,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final DateTime today;
  final List<_CalendarEvent> events;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final monthStart = DateTime(selectedDate.year, selectedDate.month);
    final gridStart = _DashboardTabState._startOfWeek(monthStart);

    return Column(
      children: [
        _WeekdayHeader(),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 42,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 78,
            mainAxisSpacing: AppSpacing.xs,
            crossAxisSpacing: AppSpacing.xs,
          ),
          itemBuilder: (context, index) {
            final date = gridStart.add(Duration(days: index));
            final dayEvents = _eventsForDay(events, date);

            return _MonthDateCell(
              date: date,
              isCurrentMonth: date.month == selectedDate.month,
              isSelected: _DashboardTabState._isSameDate(date, selectedDate),
              isToday: _DashboardTabState._isSameDate(date, today),
              events: dayEvents,
              onTap: () {
                onDateSelected(date);
                _showCalendarDetailsDialog(
                  context: context,
                  date: date,
                  events: dayEvents,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _WeekCalendarView extends StatelessWidget {
  const _WeekCalendarView({
    super.key,
    required this.selectedDate,
    required this.today,
    required this.events,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final DateTime today;
  final List<_CalendarEvent> events;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final weekStart = _DashboardTabState._startOfWeek(selectedDate);
    final days = List.generate(
      7,
      (index) => weekStart.add(Duration(days: index)),
    );

    return Column(
      children: [
        Row(
          children: [
            for (final date in days)
              Expanded(
                child: _WeekDayHeaderCell(
                  date: date,
                  isSelected: _DashboardTabState._isSameDate(
                    date,
                    selectedDate,
                  ),
                  isToday: _DashboardTabState._isSameDate(date, today),
                  onTap: () {
                    onDateSelected(date);
                    _showCalendarDetailsDialog(
                      context: context,
                      date: date,
                      events: _eventsForDay(events, date),
                    );
                  },
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        for (final hour in [8, 10, 12, 14, 16, 18])
          _WeekTimeRow(
            hour: hour,
            days: days,
            events: events,
            onDateSelected: onDateSelected,
          ),
      ],
    );
  }
}

class _DayCalendarView extends StatelessWidget {
  const _DayCalendarView({
    super.key,
    required this.selectedDate,
    required this.events,
  });

  final DateTime selectedDate;
  final List<_CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    final dayEvents = _eventsForDay(events, selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_DashboardTabState._weekdayName(selectedDate)}, ${selectedDate.day}',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.accentGreen,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final hour in List.generate(11, (index) => index + 8))
          _DayTimeSlot(
            hour: hour,
            event: dayEvents
                .where((event) => event.startHour.floor() == hour)
                .firstOrNull,
          ),
      ],
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final weekday in _DashboardTabState._weekdayNames)
          Expanded(
            child: Text(
              weekday,
              textAlign: TextAlign.center,
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colors.ash,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _MonthDateCell extends StatelessWidget {
  const _MonthDateCell({
    required this.date,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.events,
    required this.onTap,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final List<_CalendarEvent> events;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? context.colors.accentGreen
        : isToday
        ? context.colors.accentBlueGlow
        : context.colors.surfaceDeep;
    final textColor = isSelected
        ? context.colors.primaryOn
        : isCurrentMonth
        ? context.colors.ink
        : context.colors.ash;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.button,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadius.button,
            border: Border.all(
              color: isSelected || isToday
                  ? context.colors.hairlineStrong
                  : context.colors.hairline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${date.day}',
                style: context.textTheme.labelSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              for (final event in events.take(2))
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
                  child: _EventPill(event: event, compact: true),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekDayHeaderCell extends StatelessWidget {
  const _WeekDayHeaderCell({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? context.colors.accentGreen
        : isToday
        ? context.colors.accentBlueGlow
        : context.colors.surfaceDeep;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      child: InkWell(
        borderRadius: AppRadius.button,
        onTap: onTap,
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadius.button,
            border: Border.all(color: context.colors.hairline),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _DashboardTabState._weekdayNames[date.weekday - 1],
                style: context.textTheme.labelSmall,
              ),
              Text(
                '${date.day}',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? context.colors.primaryOn
                      : context.colors.ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekTimeRow extends StatelessWidget {
  const _WeekTimeRow({
    required this.hour,
    required this.days,
    required this.events,
    required this.onDateSelected,
  });

  final int hour;
  final List<DateTime> days;
  final List<_CalendarEvent> events;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: Row(
        children: [
          SizedBox(
            width: 38,
            child: Text(_hourLabel(hour), style: context.textTheme.labelSmall),
          ),
          for (final day in days)
            Builder(
              builder: (context) {
                final event = _eventForSlot(events, day, hour);

                return Expanded(
                  child: InkWell(
                    onTap: () {
                      onDateSelected(day);
                      _showCalendarDetailsDialog(
                        context: context,
                        date: day,
                        events: _eventsForDay(events, day),
                        hour: hour,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(AppSpacing.xxs),
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceDeep,
                        borderRadius: AppRadius.button,
                        border: Border.all(color: context.colors.hairline),
                      ),
                      child: event == null
                          ? const SizedBox.shrink()
                          : _EventPill(event: event),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _DayTimeSlot extends StatelessWidget {
  const _DayTimeSlot({required this.hour, required this.event});

  final int hour;
  final _CalendarEvent? event;

  @override
  Widget build(BuildContext context) {
    final calendarEvent = event;

    return Container(
      height: calendarEvent == null ? 54 : 74,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 54,
            child: Text(_hourLabel(hour), style: context.textTheme.labelSmall),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: context.colors.surfaceDeep,
                borderRadius: AppRadius.button,
                border: Border.all(color: context.colors.hairline),
              ),
              child: calendarEvent == null
                  ? const SizedBox.shrink()
                  : _EventPill(event: calendarEvent),
            ),
          ),
        ],
      ),
    );
  }
}
