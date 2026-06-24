import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class AuthTabButton extends StatelessWidget {
  const AuthTabButton({
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
      borderRadius: BorderRadius.circular(4),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.body,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              width: selected ? 78 : 0,
              height: 2,
              color: context.colors.accentRed,
            ),
          ],
        ),
      ),
    );
  }
}
