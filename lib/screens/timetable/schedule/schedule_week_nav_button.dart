import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class ScheduleWeekNavButton extends StatelessWidget {
  const ScheduleWeekNavButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
    required this.icon,
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.button,
          onTap: onPressed,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.colors.surfaceElevated,
              borderRadius: AppRadius.button,
              border: Border.all(color: context.colors.hairline),
            ),
            child: IconTheme(
              data: IconThemeData(
                color: onPressed == null
                    ? context.colors.mute
                    : context.colors.ink,
              ),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
