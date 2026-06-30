import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class ScheduleCardActionButton extends StatelessWidget {
  const ScheduleCardActionButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
    required this.icon,
    required this.color,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;

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
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.colors.surfaceDeep.withValues(alpha: 0.64),
              borderRadius: AppRadius.button,
              border: Border.all(color: context.colors.hairline),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}
