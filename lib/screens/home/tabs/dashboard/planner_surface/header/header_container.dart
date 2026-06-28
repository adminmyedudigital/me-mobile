import 'package:flutter/material.dart';

import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/screens.dart';

class PlannerSurfaceHeaderContainer extends StatelessWidget {
  const PlannerSurfaceHeaderContainer({
    super.key,
    required this.title,
    required this.calendarView,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
    required this.onPickDate,
    required this.onViewChanged,
  });

  final String title;
  final CalendarView calendarView;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final VoidCallback onPickDate;
  final ValueChanged<CalendarView> onViewChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DateNavigationContainer(
          onNext: onNext,
          onPrevious: onPrevious,
          title: title,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DateActionContainer(onPickDate: onPickDate, onToday: onToday),
            ViewSwitcherContainer(
              value: calendarView,
              onChanged: onViewChanged,
            ),
          ],
        ),
      ],
    );
  }
}
