import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class DateNavigationIconButton extends StatelessWidget {
  const DateNavigationIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.button,
          onTap: onTap,
          child: Container(
            width: 35,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.colors.surfaceElevated,
              borderRadius: AppRadius.button,
              border: Border.all(color: context.colors.hairline),
            ),
            child: Icon(icon, color: context.colors.ink),
          ),
        ),
      ),
    );
  }
}
