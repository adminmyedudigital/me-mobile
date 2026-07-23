part of 'me_multi_select_dropdown_field.dart';

class _MEMultiSelectDropdownInput<T> extends StatelessWidget {
  const _MEMultiSelectDropdownInput({
    required this.items,
    required this.value,
    required this.onChanged,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.errorText,
    this.enabled = true,
    this.showClearButton = true,
  });

  final List<MEDropdownOption<T>> items;
  final List<T> value;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final String? errorText;
  final bool enabled;
  final bool showClearButton;
  final ValueChanged<List<T>> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedLabels = [
      for (final item in items)
        if (value.contains(item.value)) item.label,
    ];
    final hasValue = selectedLabels.isNotEmpty;
    final showClearIcon = enabled && showClearButton && hasValue;
    final contentColor = enabled
        ? (hasValue ? null : colors.ash)
        : Theme.of(context).disabledColor;

    return InkWell(
      borderRadius: AppRadius.input,
      onTap: enabled ? () => _openSelectionDialog(context) : null,
      child: InputDecorator(
        isEmpty: !hasValue,
        decoration: InputDecoration(
          enabled: enabled,
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
                    onPressed: () => onChanged(const []),
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
          hasValue ? selectedLabels.join(', ') : '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: contentColor),
        ),
      ),
    );
  }

  Future<void> _openSelectionDialog(BuildContext context) async {
    final result = await _selectValues<T>(
      context,
      items: items,
      value: value,
      labelText: labelText,
    );

    if (result != null) {
      onChanged(result);
    }
  }
}
