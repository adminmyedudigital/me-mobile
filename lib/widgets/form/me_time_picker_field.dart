import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class METimePickerField extends StatelessWidget {
  const METimePickerField({
    super.key,
    required this.labelText,
    required this.onChanged,
    this.value,
    this.displayValue,
    this.prefixIcon,
    this.dialogContext,
    this.validator,
    this.onSaved,
    this.onCleared,
  });

  final TimeOfDay? value;
  final String labelText;
  final String? displayValue;
  final ValueChanged<TimeOfDay> onChanged;
  final Widget? prefixIcon;
  final BuildContext? dialogContext;
  final FormFieldValidator<TimeOfDay>? validator;
  final FormFieldSetter<TimeOfDay>? onSaved;
  final VoidCallback? onCleared;

  Future<void> _pickTime(
    BuildContext context,
    FormFieldState<TimeOfDay> field,
  ) async {
    FocusScope.of(context).unfocus();

    final picked = await showTimePicker(
      context: dialogContext ?? context,
      initialTime: value ?? TimeOfDay.now(),
      builder: (context, child) {
        final colors = context.colors;
        final baseTheme = Theme.of(context);

        return Theme(
          data: baseTheme.copyWith(
            colorScheme: baseTheme.colorScheme.copyWith(
              primary: colors.accentOrange,
              onPrimary: colors.primaryOn,
              surface: colors.surfaceCard,
              onSurface: colors.ink,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: colors.surfaceCard,
              dialHandColor: colors.accentOrange,
              dialBackgroundColor: colors.surfaceDeep,
              dialTextColor: colors.ink,
              hourMinuteColor: colors.surfaceElevated,
              hourMinuteTextColor: colors.ink,
              hourMinuteTextStyle: TextStyle(
                color: colors.ink,
                fontFamily: AppTypography.uiFont,
                fontFamilyFallback: AppTypography.bodyFallback,
                fontSize: 48,
                fontWeight: FontWeight.w500,
                height: 1,
                letterSpacing: 0,
              ),
              dayPeriodColor: colors.surfaceElevated,
              dayPeriodTextColor: colors.ink,
              dayPeriodTextStyle: TextStyle(
                color: colors.ink,
                fontFamily: AppTypography.uiFont,
                fontFamilyFallback: AppTypography.bodyFallback,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.2,
                letterSpacing: 0,
              ),
              helpTextStyle: TextStyle(
                color: colors.ink,
                fontFamily: AppTypography.uiFont,
                fontFamilyFallback: AppTypography.bodyFallback,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.2,
                letterSpacing: 0,
              ),
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(color: colors.ash),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.input,
                  borderSide: BorderSide(color: colors.ash),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.input,
                  borderSide: BorderSide(color: colors.ash, width: 1.2),
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: colors.accentOrange),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;
    field.didChange(picked);
    field.validate();
    onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FormField<TimeOfDay>(
      key: ValueKey(value),
      initialValue: value,
      validator: validator,
      onSaved: onSaved,
      builder: (field) {
        return InkWell(
          borderRadius: AppRadius.input,
          onTap: () => _pickTime(context, field),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: labelText,
              prefixIcon: prefixIcon,
              suffixIcon: value != null && onCleared != null
                  ? IconButton(
                      tooltip: 'Clear',
                      onPressed: () {
                        field.didChange(null);
                        field.validate();
                        onCleared?.call();
                      },
                      icon: const Icon(Icons.close_rounded, size: 18),
                    )
                  : null,
              errorText: field.errorText,
              labelStyle: TextStyle(color: colors.ash),
              prefixIconColor: colors.ash,
              suffixIconColor: colors.ash,
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.input,
                borderSide: BorderSide(color: colors.ash),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.input,
                borderSide: BorderSide(color: colors.ash, width: 1.2),
              ),
              errorStyle: TextStyle(color: colors.accentRed),
              errorBorder: OutlineInputBorder(
                borderRadius: AppRadius.input,
                borderSide: BorderSide(color: colors.accentRed),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: AppRadius.input,
                borderSide: BorderSide(color: colors.accentRed, width: 1.2),
              ),
            ),
            child: Text(
              displayValue ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      },
    );
  }
}
