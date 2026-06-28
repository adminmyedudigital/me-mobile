import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';
import 'package:me_mobile/controllers/dashboard_controller.dart';

class DayTimeSlot extends StatelessWidget {
  const DayTimeSlot({super.key, required this.hour, required this.events});

  final int hour;
  final List<DashboardEvent> events;

  @override
  Widget build(BuildContext context) {
    final hasEvents = events.isNotEmpty;

    return Container(
      constraints: BoxConstraints(minHeight: hasEvents ? 74 : 54),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 54,
            child: Text(
              DashboardDateUtils.hourLabel(hour),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Expanded(
            child: Container(
              constraints: BoxConstraints(minHeight: hasEvents ? 58 : 54),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: context.colors.surfaceDeep,
                borderRadius: AppRadius.button,
                border: Border.all(color: context.colors.hairline),
              ),
              child: !hasEvents
                  ? const SizedBox.shrink()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final event in events) ...[
                          DayEventCountBadge(event: event),
                          if (event != events.last)
                            const SizedBox(height: AppSpacing.xs),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
