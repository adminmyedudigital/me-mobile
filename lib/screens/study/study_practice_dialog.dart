import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/widgets.dart';

class StudyPracticeDialog extends StatefulWidget {
  const StudyPracticeDialog({required this.title, super.key});

  final String title;

  @override
  State<StudyPracticeDialog> createState() => _StudyPracticeDialogState();
}

class _StudyPracticeDialogState extends State<StudyPracticeDialog> {
  static const Map<String, List<String>> _topicsBySubject = {
    'Mathematics': ['Algebra', 'Geometry', 'Trigonometry', 'Statistics'],
    'Science': ['Physics', 'Chemistry', 'Biology', 'Environment'],
    'English': ['Grammar', 'Writing', 'Reading comprehension', 'Literature'],
    'Social Science': ['History', 'Geography', 'Civics', 'Economics'],
  };

  static const List<MEDropdownOption<String>> _subjectOptions = [
    MEDropdownOption(value: 'Mathematics', label: 'Mathematics'),
    MEDropdownOption(value: 'Science', label: 'Science'),
    MEDropdownOption(value: 'English', label: 'English'),
    MEDropdownOption(value: 'Social Science', label: 'Social Science'),
  ];

  final _formKey = GlobalKey<FormState>();
  String? _subject;
  String? _topic;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final autovalidateMode = _submitted
        ? AutovalidateMode.always
        : AutovalidateMode.disabled;
    final topicOptions = [
      for (final topic in _topicsBySubject[_subject] ?? <String>[])
        MEDropdownOption(value: topic, label: topic),
    ];

    return AlertDialog(
      backgroundColor: isLightTheme
          ? colors.surfaceCard
          : colors.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      title: Text(widget.title),
      content: SizedBox(
        width: 320,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MEDropdownField<String>(
                  items: _subjectOptions,
                  initialValue: _subject,
                  labelText: 'Subject',
                  hintText: 'Select Subject',
                  prefixIcon: const Icon(Icons.menu_book_outlined),
                  autovalidateMode: autovalidateMode,
                  validator: _requiredSelection('Subject'),
                  onChanged: (value) {
                    setState(() {
                      _subject = value;
                      _topic = null;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                MEDropdownField<String>(
                  key: ValueKey(_subject),
                  items: topicOptions,
                  initialValue: _topic,
                  labelText: 'Topic',
                  hintText: 'Select Topic',
                  prefixIcon: const Icon(Icons.topic_outlined),
                  autovalidateMode: autovalidateMode,
                  validator: _requiredSelection('Topic'),
                  onChanged: (value) {
                    setState(() => _topic = value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        MEButton(
          label: 'Cancel',
          fullWidth: true,
          backgroundColor: colors.primaryOn,
          foregroundColor: colors.ink,
          onPressed: () => Get.back<StudyPracticeSelection>(),
        ),
        SizedBox(height: AppSpacing.sm),
        MEButton(
          label: 'Confirm',
          fullWidth: true,
          backgroundColor: colors.primary,
          foregroundColor: colors.primaryOn,
          onPressed: _confirm,
        ),
      ],
    );
  }

  void _confirm() {
    setState(() => _submitted = true);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final subject = _subject;
    final topic = _topic;
    if (subject == null || topic == null) {
      return;
    }

    Get.back(
      result: StudyPracticeSelection(subject: subject, topic: topic),
    );
  }

  FormFieldValidator<String> _requiredSelection(String fieldName) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName is required';
      }
      return null;
    };
  }
}
