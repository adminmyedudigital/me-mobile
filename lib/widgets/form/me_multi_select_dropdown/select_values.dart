part of 'me_multi_select_dropdown_field.dart';

Future<List<T>?> _selectValues<T>(
  BuildContext context, {
  required List<MEDropdownOption<T>> items,
  required List<T> value,
  String? labelText,
}) {
  final selectedValues = List<T>.of(value);

  return showDialog<List<T>>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final colors = context.colors;

          if (items.isEmpty) {
            return AlertDialog(
              title: Text(labelText ?? 'Select options'),
              contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
              content: const Text(
                'No options available',
                textAlign: TextAlign.center,
              ),
              actions: [
                MEButton(
                  label: 'Close',
                  fullWidth: true,
                  backgroundColor: colors.primary,
                  foregroundColor: colors.primaryOn,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          }

          final allValues = items.map((item) => item.value).toList();
          final selectedCount = allValues.where(selectedValues.contains).length;
          final allSelected = selectedCount == allValues.length;
          final selectAllValue = selectedCount == 0
              ? false
              : allSelected
              ? true
              : null;

          return AlertDialog(
            title: Text(labelText ?? 'Select options'),
            content: SizedBox(
              width: 360,
              child: ListView(
                shrinkWrap: true,
                children: [
                  CheckboxListTile(
                    tristate: true,
                    value: selectAllValue,
                    title: const Text('Select all'),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (_) {
                      setDialogState(() {
                        selectedValues
                          ..clear()
                          ..addAll(allSelected ? const [] : allValues);
                      });
                    },
                  ),
                  const Divider(),
                  for (final item in items)
                    CheckboxListTile(
                      value: selectedValues.contains(item.value),
                      title: Text(item.label),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (isSelected) {
                        setDialogState(() {
                          if (isSelected == true) {
                            if (!selectedValues.contains(item.value)) {
                              selectedValues.add(item.value);
                            }
                          } else {
                            selectedValues.remove(item.value);
                          }
                        });
                      },
                    ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            actions: [
              SizedBox(
                width: 360,
                child: Row(
                  children: [
                    Expanded(
                      child: MEButton(
                        label: 'Clear all',
                        fullWidth: true,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        backgroundColor: colors.surfaceCard,
                        foregroundColor: colors.ink,
                        disabledBackgroundColor: colors.surfaceCard,
                        disabledForegroundColor: colors.mute,
                        onPressed: selectedValues.isEmpty
                            ? null
                            : () => setDialogState(selectedValues.clear),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: MEButton(
                        label: 'Cancel',
                        fullWidth: true,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        backgroundColor: colors.surfaceCard,
                        foregroundColor: colors.ink,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: MEButton(
                        label: 'Done',
                        fullWidth: true,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        backgroundColor: colors.primary,
                        foregroundColor: colors.primaryOn,
                        onPressed: () =>
                            Navigator.of(context).pop(selectedValues),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
