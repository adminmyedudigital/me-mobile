import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class ViewSwitcherButton extends StatelessWidget {
  const ViewSwitcherButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.button,
      onTap: onTap,
      child: Container(
        height: 25,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? context.colors.accentOrange : Colors.transparent,
          borderRadius: AppRadius.button,
        ),
        child: Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: selected ? context.colors.canvas : context.colors.ink,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
