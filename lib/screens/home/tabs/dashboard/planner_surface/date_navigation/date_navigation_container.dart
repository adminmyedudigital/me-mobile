import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/home/tabs/dashboard/planner_surface/date_navigation/date_navigation_icon_button.dart';

class DateNavigationContainer extends StatelessWidget {
  const DateNavigationContainer({
    super.key,
    required this.title,
    required this.onPrevious,
    required this.onNext,
  });

  final String title;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DateNavigationIconButton(
          icon: Icons.chevron_left,
          tooltip: 'Previous',
          onTap: onPrevious,
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            title,
            style: context.textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        DateNavigationIconButton(
          icon: Icons.chevron_right,
          tooltip: 'Next',
          onTap: onNext,
        ),
      ],
    );
  }
}
