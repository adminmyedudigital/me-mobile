import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class FlashCardFeedbackIconButton extends StatelessWidget {
  const FlashCardFeedbackIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Icon(icon),
      color: isSelected ? context.colors.primaryOn : color,
      style: IconButton.styleFrom(
        backgroundColor: isSelected ? color : color.withValues(alpha: 0.1),
        side: BorderSide(color: color.withValues(alpha: isSelected ? 1 : 0.24)),
        fixedSize: const Size(44, 44),
      ),
    );
  }
}
