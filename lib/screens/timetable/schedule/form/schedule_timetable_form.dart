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
  late List<String> _subTopicOptions;
  late String? _subTopicName;
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

    final subjects = _controller.subjects;
    _subjectName =
        item?.subjectName ?? (subjects.isEmpty ? null : subjects.first);
    if (!_controller.subjects.contains(_subjectName)) {
      _subjectName = subjects.isEmpty ? null : subjects.first;
    }

    _topicOptions = _controller.topicsForSubject(_subjectName ?? '');
    _topicName =
        item?.topicName ?? (_topicOptions.isEmpty ? null : _topicOptions.first);
    if (!_topicOptions.contains(_topicName)) {
      _topicName = _topicOptions.isEmpty ? null : _topicOptions.first;
    }

    _subTopicOptions = _controller.subTopicsForSubjectTopic(
      _subjectName ?? '',
      _topicName ?? '',
    );
    _subTopicName =
        item?.subTopicName ??
        (_subTopicOptions.isEmpty ? null : _subTopicOptions.first);
    if (!_subTopicOptions.contains(_subTopicName)) {
      _subTopicName = _subTopicOptions.isEmpty ? null : _subTopicOptions.first;
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
                  validator: _controller.validateRequiredSelection,
                  onChanged: (value) {
                    setState(() {
                      _subjectName = value;
                      _topicOptions = _controller.topicsForSubject(value ?? '');
                      _topicName = _topicOptions.isEmpty
                          ? null
                          : _topicOptions.first;
                      _setSubTopicOptions();
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
                  validator: _controller.validateRequiredSelection,
                  onChanged: (value) {
                    setState(() {
                      _topicName = value;
                      _setSubTopicOptions();
                    });
                  },
                  onSaved: (value) => _topicName = value ?? '',
                ),
                const SizedBox(height: AppSpacing.md),
                MEDropdownField<String>(
                  initialValue: _subTopicName,
                  labelText: 'Sub topic',
                  showClearButton: true,
                  prefixIcon: const Icon(Icons.subdirectory_arrow_right),
                  items: [
                    for (final subTopic in _subTopicOptions)
                      MEDropdownOption(value: subTopic, label: subTopic),
                  ],
                  validator: _controller.validateRequiredSelection,
                  onChanged: (value) {
                    setState(() => _subTopicName = value);
                  },
                  onSaved: (value) => _subTopicName = value ?? '',
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
                        validator: (date) => _controller.validateStudyDate(
                          date,
                          firstSelectableDate: _firstSelectableDate,
                          weekEnd: _weekEnd,
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
                        validator: _controller.validateStudyTime,
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
                        validator: _controller.validateStudyHours,
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
                            value: 'Exam Preparation',
                            label: 'Exam Preparation',
                          ),
                        ],
                        validator: _controller.validateRequiredSelection,
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
                  validator: _controller.validateSuggestion,
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
    if (!(_formKey.currentState?.validate() ?? false)) {
      _controller.showFormValidationError();
      return;
    }
    _formKey.currentState?.save();

    final selectedTime = _startTime;
    final selectedDate = _studyDate;
    final selectedSubject = _subjectName;
    final selectedTopic = _topicName;
    final selectedSubTopic = _subTopicName;
    final selectedKind = _kind;
    if (selectedTime == null ||
        selectedDate == null ||
        selectedSubject == null ||
        selectedTopic == null ||
        selectedSubTopic == null ||
        selectedKind == null) {
      _controller.showFormValidationError();
      return;
    }

    final nextItem = ScheduleTimetableItem(
      id: _item?.id ?? 0,
      subjectName: selectedSubject.trim(),
      topicName: selectedTopic.trim(),
      subTopicName: selectedSubTopic.trim(),
      studyDate: selectedDate,
      startHour: _hourFromTimeOfDay(selectedTime),
      studyHours: double.parse(_studyHours),
      kind: selectedKind,
      suggestion: _suggestion.trim(),
      isSystemGenerated: false,
    );

    final didSave = _item == null
        ? _controller.addItem(nextItem)
        : _controller.updateItem(nextItem);
    if (!didSave) return;

    Navigator.of(context).pop();
  }

  void _setSubTopicOptions() {
    _subTopicOptions = _controller.subTopicsForSubjectTopic(
      _subjectName ?? '',
      _topicName ?? '',
    );
    _subTopicName = _subTopicOptions.isEmpty ? null : _subTopicOptions.first;
  }
}

TimeOfDay _timeOfDayFromHour(double hour) {
  final selectedHour = hour.floor();
  final selectedMinute = ((hour - selectedHour) * 60).round();

  return TimeOfDay(hour: selectedHour, minute: selectedMinute);
}

double _hourFromTimeOfDay(TimeOfDay time) {
  return time.hour + time.minute / 60;
}
