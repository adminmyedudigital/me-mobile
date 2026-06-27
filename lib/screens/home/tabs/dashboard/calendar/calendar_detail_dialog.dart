part of '../dashboard_tab.dart';

Future<void> _showCalendarDetailsDialog({
  required BuildContext context,
  required DateTime date,
  required List<DashboardEvent> events,
  int? hour,
}) {
  final visibleEvents = hour == null
      ? events
      : events.where((event) => event.startHour.floor() == hour).toList();

  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: context.colors.surfaceCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
        titlePadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.sm,
        ),
        contentPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        title: Row(
          children: [
            Icon(Icons.event_note_outlined, color: context.colors.accentGreen),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                hour == null ? 'Day details' : 'Time block details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _detailsDateLabel(date, hour),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.accentBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (visibleEvents.isEmpty)
                _EmptyCalendarDetails(hour: hour)
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: visibleEvents.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      return _CalendarDetailEventTile(
                        event: visibleEvents[index],
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

class _CalendarDetailEventTile extends StatelessWidget {
  const _CalendarDetailEventTile({required this.event});

  final DashboardEvent event;

  @override
  Widget build(BuildContext context) {
    final color = event.color(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceElevated,
        borderRadius: AppRadius.card,
        border: Border.all(color: context.colors.hairline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  event.timeLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCalendarDetails extends StatelessWidget {
  const _EmptyCalendarDetails({required this.hour});

  final int? hour;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surfaceElevated,
        borderRadius: AppRadius.card,
        border: Border.all(color: context.colors.hairline),
      ),
      child: Text(
        hour == null
            ? 'No events scheduled for this date.'
            : 'No events scheduled in this time block.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

String _detailsDateLabel(DateTime date, int? hour) {
  final day = DashboardDateUtils.weekdayName(date);
  final month = DashboardDateUtils.monthNames[date.month - 1];
  final dateLabel = '$day, ${date.day} $month ${date.year}';

  if (hour == null) return dateLabel;

  return '$dateLabel • ${DashboardDateUtils.hourLabel(hour)}';
}
