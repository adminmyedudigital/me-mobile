import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({
    required this.enabledTooltip,
    required this.onPressed,
    this.disabledTooltip = 'Complete academic setup first',
    super.key,
  });

  final String enabledTooltip;
  final String disabledTooltip;
  final VoidCallback? onPressed;

  bool get _isEnabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: _isEnabled
            ? [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.28),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: colors.canvas.withValues(alpha: 0.32),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: FloatingActionButton(
        tooltip: _isEnabled ? enabledTooltip : disabledTooltip,
        elevation: 0,
        disabledElevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        backgroundColor: _isEnabled ? colors.primary : colors.stone,
        foregroundColor: _isEnabled ? colors.primaryOn : colors.mute,
        shape: CircleBorder(
          side: BorderSide(color: colors.primaryOn.withValues(alpha: 0.12)),
        ),
        onPressed: onPressed,
        child: const Icon(Icons.add_rounded, size: 30),
      ),
    );
  }
}
