import 'package:flutter/material.dart';

import 'package:me_mobile/theme/app_theme_context.dart';
import 'package:me_mobile/controllers/dashboard_controller.dart';

class WeekNameHeader extends StatelessWidget {
  const WeekNameHeader({super.key, required this.isLightTheme});

  final bool isLightTheme;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isLightTheme
            ? colors.surfaceElevated.withValues(alpha: 0.74)
            : colors.surfaceDeep.withValues(alpha: 0.9),
      ),
      child: Row(
        children: [
          for (final weekday in DashboardDateUtils.weekdayNames)
            Expanded(
              child: Text(
                weekday,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isLightTheme ? colors.primary : colors.ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
