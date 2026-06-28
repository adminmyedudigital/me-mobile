import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/screens/screens.dart';

class ViewSwitcherContainer extends StatelessWidget {
  const ViewSwitcherContainer({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final CalendarView value;
  final ValueChanged<CalendarView> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: context.colors.surfaceElevated,
        borderRadius: AppRadius.button,
        border: Border.all(color: context.colors.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ViewSwitcherButton(
            label: 'Day',
            selected: value == CalendarView.day,
            onTap: () => onChanged(CalendarView.day),
          ),
          ViewSwitcherButton(
            label: 'Week',
            selected: value == CalendarView.week,
            onTap: () => onChanged(CalendarView.week),
          ),
          ViewSwitcherButton(
            label: 'Month',
            selected: value == CalendarView.month,
            onTap: () => onChanged(CalendarView.month),
          ),
        ],
      ),
    );
  }
}
