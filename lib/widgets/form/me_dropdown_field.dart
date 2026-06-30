import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class MEDropdownOption<T> {
  const MEDropdownOption({required this.value, required this.label});

  final T value;
  final String label;
}

class MEDropdownField<T> extends StatelessWidget {
  const MEDropdownField({
    super.key,
    required this.items,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.showClearButton = false,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.onSaved,
  });

  final List<MEDropdownOption<T>> items;
  final T? initialValue;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final bool showClearButton;
  final FormFieldValidator<T>? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<T?>? onChanged;
  final FormFieldSetter<T>? onSaved;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasInitialValue = items.any((item) => item.value == initialValue);
    final resolvedValue = hasInitialValue ? initialValue : null;

    return DropdownButtonFormField<T>(
      key: ValueKey(resolvedValue),
      initialValue: resolvedValue,
      isExpanded: true,
      style: Theme.of(context).textTheme.bodyMedium,
      dropdownColor: colors.surfaceCard,
      iconEnabledColor: colors.ash,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: showClearButton && resolvedValue != null
            ? IconButton(
                tooltip: 'Clear',
                onPressed: () => onChanged?.call(null),
                icon: const Icon(Icons.close_rounded, size: 18),
              )
            : null,
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
      items: [
        for (final item in items)
          DropdownMenuItem<T>(
            value: item.value,
            child: Text(item.label, overflow: TextOverflow.ellipsis),
          ),
      ],
      validator: validator,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }
}
