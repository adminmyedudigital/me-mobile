import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/form/me_button.dart';
import 'package:me_mobile/widgets/form/me_dropdown_field.dart';

part 'select_values.dart';
part 'me_multi_select_dropdown_input.dart';

class MEMultiSelectDropdownField<T> extends StatelessWidget {
  const MEMultiSelectDropdownField({
    super.key,
    required this.items,
    this.initialValue = const [],
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.enabled = true,
    this.showClearButton = true,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.onSaved,
  });

  final List<MEDropdownOption<T>> items;
  final List<T> initialValue;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final bool enabled;
  final bool showClearButton;
  final FormFieldValidator<List<T>>? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<List<T>>? onChanged;
  final FormFieldSetter<List<T>>? onSaved;

  @override
  Widget build(BuildContext context) {
    final availableValues = items.map((item) => item.value);
    final resolvedValue = initialValue
        .where(availableValues.contains)
        .toList(growable: false);

    return FormField<List<T>>(
      enabled: enabled,
      initialValue: resolvedValue,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onSaved: onSaved,
      builder: (field) {
        final value = field.value ?? const [];

        void changeValue(List<T> newValue) {
          final valueCopy = List<T>.unmodifiable(newValue);
          field.didChange(valueCopy);
          field.validate();
          onChanged?.call(valueCopy);
        }

        return _MEMultiSelectDropdownInput<T>(
          items: items,
          value: value,
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          errorText: field.errorText,
          enabled: enabled,
          showClearButton: showClearButton,
          onChanged: changeValue,
        );
      },
    );
  }
}
