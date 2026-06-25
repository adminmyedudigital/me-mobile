import 'package:flutter/material.dart';
import 'package:me_mobile/theme/app_spacing.dart';
import 'package:me_mobile/screens/home/tabs/dashboard/date_actions/date_action_button.dart';

class DateActionContainer extends StatelessWidget {
  const DateActionContainer({
    super.key,
    required this.onPickDate,
    required this.onToday,
  });

  final VoidCallback onToday;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DateActionButton(
          icon: Icons.today_outlined,
          label: 'Today',
          onTap: onToday,
        ),
        const SizedBox(width: AppSpacing.sm),
        DateActionButton(
          icon: Icons.edit_calendar_outlined,
          label: 'Date',
          onTap: onPickDate,
        ),
      ],
    );
  }
}
