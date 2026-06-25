part of '../dashboard_tab.dart';

class _EventPill extends StatelessWidget {
  const _EventPill({required this.event, this.compact = false});

  final _CalendarEvent event;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = event.color(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
        vertical: compact ? AppSpacing.xxs : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(compact ? 42 : 54),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: color.withAlpha(130)),
      ),
      child: Text(
        compact ? event.title : '${event.timeLabel}  ${event.title}',
        maxLines: compact ? 1 : 2,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colors.ink,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
    );
  }
}
