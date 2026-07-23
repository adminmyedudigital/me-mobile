import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class MEButton extends StatelessWidget {
  const MEButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.disabled = false,
    this.fullWidth = false,
    this.width = 174,
    this.height = 46,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.padding,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool disabled;
  final bool fullWidth;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final defaultForegroundColor = colors.ink;
    final resolvedForegroundColor = foregroundColor ?? defaultForegroundColor;
    final resolvedDisabledForegroundColor =
        disabledForegroundColor ?? colors.mute;
    final isDisabled = disabled || isLoading || onPressed == null;
    final labelColor = isDisabled
        ? resolvedDisabledForegroundColor
        : resolvedForegroundColor;

    final button = SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height,
      child: FilledButton(
        onPressed: isDisabled ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor ?? colors.link,
          foregroundColor: resolvedForegroundColor,
          disabledBackgroundColor: disabledBackgroundColor ?? colors.stone,
          disabledForegroundColor: resolvedDisabledForegroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: _MEFormButtonLabel(
                  label: label,
                  icon: icon,
                  color: labelColor,
                ),
              ),
            ),
            if (isLoading) ...[
              const SizedBox(width: AppSpacing.sm),
              SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  color: labelColor,
                  strokeWidth: 2,
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (fullWidth) {
      return button;
    }

    return Center(child: button);
  }
}

class _MEFormButtonLabel extends StatelessWidget {
  const _MEFormButtonLabel({
    required this.label,
    required this.color,
    this.icon,
  });

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.bodyMedium?.copyWith(
      color: color,
      letterSpacing: 0,
    );

    if (icon == null) {
      return Text(label, style: textStyle);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: textStyle),
      ],
    );
  }
}
