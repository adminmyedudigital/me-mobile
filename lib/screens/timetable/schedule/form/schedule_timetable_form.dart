import 'package:flutter/material.dart';

import 'package:me_mobile/controllers/controllers.dart';
import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/widgets.dart';

class ScheduleTimetableForm extends StatefulWidget {
  const ScheduleTimetableForm({
    required this.parentContext,
    required this.controller,
    this.item,
    this.initialDate,
    super.key,
  });

  final BuildContext parentContext;
  final ScheduleTimetableController controller;
  final ScheduleTimetableItem? item;
  final DateTime? initialDate;

  @override
  State<ScheduleTimetableForm> createState() => _ScheduleTimetableFormState();
}

class _ScheduleTimetableFormState extends State<ScheduleTimetableForm> {
  final _formKey = GlobalKey<FormState>();

  late final DateTime _weekStart;
  late final DateTime _weekEnd;
  late final DateTime _firstSelectableDate;
  late String? _subjectName;
  late List<String> _topicOptions;
  late String? _topicName;
  late DateTime? _studyDate;
  late TimeOfDay? _startTime;
  late String _studyHours;
  late String? _kind;
  late String _suggestion;

  ScheduleTimetableController get _controller => widget.controller;
  ScheduleTimetableItem? get _item => widget.item;

  @override
  void initState() {
    super.initState();

    final item = _item;
    _weekStart = _controller.weekStart.value;
    _weekEnd = _weekStart.add(const Duration(days: 6));
    _firstSelectableDate = _weekStart.isBefore(_controller.today)
        ? _controller.today
        : _weekStart;

    _subjectName = item?.subjectName ?? _controller.subjects.first;
    if (!_controller.subjects.contains(_subjectName)) {
      _subjectName = _controller.subjects.first;
    }

    _topicOptions = _controller.topicsForSubject(_subjectName ?? '');
    _topicName =
        item?.topicName ?? (_topicOptions.isEmpty ? null : _topicOptions.first);
    if (!_topicOptions.contains(_topicName)) {
      _topicName = _topicOptions.isEmpty ? null : _topicOptions.first;
    }

    _studyDate = item?.studyDate ?? widget.initialDate ?? _controller.today;
    if (_studyDate!.isBefore(_firstSelectableDate) ||
        _studyDate!.isAfter(_weekEnd)) {
      _studyDate = _firstSelectableDate;
    }

    _startTime = item == null ? null : _timeOfDayFromHour(item.startHour);
    _studyHours = item?.studyHours.toString() ?? '1';
    _kind = item?.kind ?? 'Practice';
    _suggestion = item?.suggestion ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: AppRadius.card,
        border: Border.all(color: colors.hairlineStrong),
        boxShadow: [
          BoxShadow(
            color: colors.canvas.withValues(alpha: 0.48),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.hairlineStrong,
                      borderRadius: AppRadius.pill,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  _item == null ? 'Add study plan' : 'Update study plan',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.lg),
                MEDropdownField<String>(
                  initialValue: _subjectName,
                  labelText: 'Subject',
                  showClearButton: true,
                  prefixIcon: const Icon(Icons.menu_book_outlined),
                  items: [
                    for (final subject in _controller.subjects)
                      MEDropdownOption(value: subject, label: subject),
                  ],
                  validator: _requiredDropdownValidator,
                  onChanged: (value) {
                    setState(() {
                      _subjectName = value;
                      _topicOptions = _controller.topicsForSubject(value ?? '');
                      _topicName = _topicOptions.isEmpty
                          ? null
                          : _topicOptions.first;
                    });
                  },
                  onSaved: (value) => _subjectName = value ?? '',
                ),
                const SizedBox(height: AppSpacing.md),
                MEDropdownField<String>(
                  initialValue: _topicName,
                  labelText: 'Topic',
                  showClearButton: true,
                  prefixIcon: const Icon(Icons.topic_outlined),
                  items: [
                    for (final topic in _topicOptions)
                      MEDropdownOption(value: topic, label: topic),
                  ],
                  validator: _requiredDropdownValidator,
                  onChanged: (value) {
                    setState(() => _topicName = value);
                  },
                  onSaved: (value) => _topicName = value ?? '',
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: MEDatePickerField(
                        value: _studyDate,
                        firstDate: _firstSelectableDate,
                        lastDate: _weekEnd,
                        labelText: 'Study date',
                        displayValue: _studyDate == null
                            ? 'Select'
                            : _controller.dateLabel(_studyDate!),
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        dialogContext: widget.parentContext,
                        validator: (date) => _dateValidator(
                          date,
                          _controller,
                          _firstSelectableDate,
                          _weekEnd,
                        ),
                        onChanged: (date) {
                          setState(() => _studyDate = date);
                        },
                        onCleared: () {
                          setState(() => _studyDate = null);
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: METimePickerField(
                        value: _startTime,
                        labelText: 'Study time',
                        displayValue: _startTime == null
                            ? 'Select'
                            : _controller.timeLabel(
                                _hourFromTimeOfDay(_startTime!),
                              ),
                        prefixIcon: const Icon(Icons.schedule_outlined),
                        dialogContext: widget.parentContext,
                        validator: _timeValidator,
                        onChanged: (time) {
                          setState(() => _startTime = time);
                        },
                        onCleared: () {
                          setState(() => _startTime = null);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: METextField(
                        initialValue: _studyHours,
                        labelText: 'Study hours',
                        prefixIcon: const Icon(Icons.timer_outlined),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _hoursValidator,
                        onChanged: (value) => _studyHours = value,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: MEDropdownField<String>(
                        initialValue: _kind,
                        labelText: 'Plan type',
                        showClearButton: true,
                        prefixIcon: const Icon(Icons.auto_awesome_outlined),
                        items: const [
                          MEDropdownOption(
                            value: 'Practice',
                            label: 'Practice',
                          ),
                          MEDropdownOption(
                            value: 'Revision',
                            label: 'Revision',
                          ),
                          MEDropdownOption(
                            value: 'Exam paper',
                            label: 'Exam paper',
                          ),
                        ],
                        validator: _requiredDropdownValidator,
                        onChanged: (value) {
                          setState(() => _kind = value);
                        },
                        onSaved: (value) => _kind = value ?? 'Practice',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                METextField(
                  initialValue: _suggestion,
                  labelText: 'Suggestion',
                  prefixIcon: const Icon(Icons.lightbulb_outline),
                  minLines: 3,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  validator: _suggestionValidator,
                  onChanged: (value) => _suggestion = value,
                ),
                const SizedBox(height: AppSpacing.lg),
                MEButton(
                  fullWidth: true,
                  onPressed: _submit,
                  icon: _item == null ? Icons.add : Icons.check,
                  label: _item == null ? 'Add plan' : 'Save plan',
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.surfaceCard,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();

    final selectedTime = _startTime;
    final selectedDate = _studyDate;
    final selectedSubject = _subjectName;
    final selectedTopic = _topicName;
    final selectedKind = _kind;
    if (selectedTime == null ||
        selectedDate == null ||
        selectedSubject == null ||
        selectedTopic == null ||
        selectedKind == null) {
      return;
    }

    final nextItem = ScheduleTimetableItem(
      id: _item?.id ?? 0,
      subjectName: selectedSubject.trim(),
      topicName: selectedTopic.trim(),
      studyDate: selectedDate,
      startHour: _hourFromTimeOfDay(selectedTime),
      studyHours: double.parse(_studyHours),
      kind: selectedKind,
      suggestion: _suggestion.trim(),
      isSystemGenerated: false,
    );

    if (_item == null) {
      _controller.addItem(nextItem);
    } else {
      _controller.updateItem(nextItem);
    }

    Navigator.of(context).pop();
  }
}

String? _requiredDropdownValidator<T>(T? value) {
  if (value == null) {
    return 'Required';
  }

  return null;
}

String? _dateValidator(
  DateTime? value,
  ScheduleTimetableController controller,
  DateTime firstSelectableDate,
  DateTime weekEnd,
) {
  if (value == null) {
    return 'Required';
  }

  if (value.isBefore(controller.today)) {
    return 'Past dates are not allowed';
  }

  if (value.isBefore(firstSelectableDate) || value.isAfter(weekEnd)) {
    return 'Select a date from this week';
  }

  return null;
}

String? _timeValidator(TimeOfDay? value) {
  if (value == null) {
    return 'Required';
  }

  return null;
}

String? _hoursValidator(String? value) {
  final hours = double.tryParse(value ?? '');
  if (hours == null || hours <= 0) {
    return 'Enter hours greater than 0';
  }

  if (hours > 8) {
    return 'Max 8 hours';
  }

  return null;
}

String? _suggestionValidator(String? value) {
  final suggestion = value?.trim() ?? '';
  if (suggestion.isEmpty) {
    return null;
  }

  if (suggestion.length < 10) {
    return 'Minimum 10 characters';
  }

  if (suggestion.length > 200) {
    return 'Maximum 200 characters';
  }

  return null;
}

TimeOfDay _timeOfDayFromHour(double hour) {
  final selectedHour = hour.floor();
  final selectedMinute = ((hour - selectedHour) * 60).round();

  return TimeOfDay(hour: selectedHour, minute: selectedMinute);
}

double _hourFromTimeOfDay(TimeOfDay time) {
  return time.hour + time.minute / 60;
}
