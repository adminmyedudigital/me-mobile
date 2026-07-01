import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class MEDatePickerField extends StatelessWidget {
  const MEDatePickerField({
    super.key,
    required this.firstDate,
    required this.lastDate,
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

  final DateTime? value;
  final DateTime firstDate;
  final DateTime lastDate;
  final String labelText;
  final String? displayValue;
  final ValueChanged<DateTime> onChanged;
  final Widget? prefixIcon;
  final BuildContext? dialogContext;
  final FormFieldValidator<DateTime>? validator;
  final FormFieldSetter<DateTime>? onSaved;
  final VoidCallback? onCleared;

  Future<void> _pickDate(
    BuildContext context,
    FormFieldState<DateTime> field,
  ) async {
    FocusScope.of(context).unfocus();

    final picked = await showDatePicker(
      context: dialogContext ?? context,
      initialDate: value ?? firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
      confirmText: 'Select',
      cancelText: 'Cancel',
      builder: (context, child) {
        return _MEDatePickerTheme(child: child!);
      },
    );

    if (picked == null) return;
    field.didChange(picked);
    field.validate();
    onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      key: ValueKey(value),
      initialValue: value,
      validator: validator,
      onSaved: onSaved,
      builder: (field) {
        return _MEPickerField(
          labelText: labelText,
          displayValue: displayValue ?? '',
          prefixIcon: prefixIcon,
          errorText: field.errorText,
          showClearButton: value != null && onCleared != null,
          onCleared: () {
            field.didChange(null);
            field.validate();
            onCleared?.call();
          },
          onTap: () => _pickDate(context, field),
        );
      },
    );
  }
}

class _MEDatePickerTheme extends StatelessWidget {
  const _MEDatePickerTheme({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
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
        dialogTheme: DialogThemeData(
          backgroundColor: colors.surfaceCard,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: colors.surfaceCard,
          headerBackgroundColor: colors.surfaceDeep,
          headerForegroundColor: colors.ink,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: colors.accentOrange),
        ),
      ),
      child: child,
    );
  }
}

class _MEPickerField extends StatelessWidget {
  const _MEPickerField({
    required this.labelText,
    required this.displayValue,
    required this.onTap,
    this.prefixIcon,
    this.errorText,
    this.showClearButton = false,
    this.onCleared,
  });

  final String labelText;
  final String displayValue;
  final VoidCallback onTap;
  final Widget? prefixIcon;
  final String? errorText;
  final bool showClearButton;
  final VoidCallback? onCleared;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      borderRadius: AppRadius.input,
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: showClearButton
              ? SizedBox.square(
                  dimension: 48,
                  child: IconButton(
                    tooltip: 'Clear',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 48,
                      height: 48,
                    ),
                    onPressed: onCleared,
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
                )
              : null,
          errorText: errorText,
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
          displayValue,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
