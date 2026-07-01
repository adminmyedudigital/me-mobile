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
    final hasInitialValue = items.any((item) => item.value == initialValue);
    final resolvedValue = hasInitialValue ? initialValue : null;

    return FormField<T>(
      key: ValueKey(resolvedValue),
      initialValue: resolvedValue,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onSaved: onSaved,
      builder: (field) {
        return _MEDropdownInput<T>(
          items: items,
          value: field.value,
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          errorText: field.errorText,
          showClearButton: showClearButton,
          onChanged: (value) {
            field.didChange(value);
            field.validate();
            onChanged?.call(value);
          },
        );
      },
    );
  }
}

class _MEDropdownInput<T> extends StatelessWidget {
  const _MEDropdownInput({
    required this.items,
    required this.onChanged,
    this.value,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.errorText,
    this.showClearButton = false,
  });

  final List<MEDropdownOption<T>> items;
  final T? value;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final String? errorText;
  final bool showClearButton;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedOption = _selectedOption;
    final hasValue = selectedOption != null;
    final showClearIcon = showClearButton && hasValue;

    return PopupMenuButton<T>(
      tooltip: '',
      color: colors.surfaceCard,
      position: PopupMenuPosition.under,
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final item in items)
          PopupMenuItem<T>(
            value: item.value,
            child: Text(item.label, overflow: TextOverflow.ellipsis),
          ),
      ],
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: SizedBox.square(
            dimension: 48,
            child: showClearIcon
                ? IconButton(
                    tooltip: 'Clear',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 48,
                      height: 48,
                    ),
                    onPressed: () => onChanged(null),
                    icon: const Icon(Icons.close_rounded, size: 18),
                  )
                : Icon(Icons.keyboard_arrow_down_rounded, color: colors.ash),
          ),
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
          selectedOption?.label ?? hintText ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: hasValue ? null : colors.ash),
        ),
      ),
    );
  }

  MEDropdownOption<T>? get _selectedOption {
    for (final item in items) {
      if (item.value == value) return item;
    }

    return null;
  }
}
