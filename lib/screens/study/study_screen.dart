import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/routes/app_routes.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.band,
          ),
          children: [
            Card(
              color: context.colors.surfaceElevated,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.school_outlined),
                    title: const Text('Academic Setup'),
                    subtitle: const Text(
                      'Setup your academic year, school and class',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.toNamed(AppRoutes.academicSetup),
                  ),
                  Divider(color: context.colors.hairline),
                  ListTile(
                    leading: const Icon(Icons.style_rounded),
                    title: const Text('Flash cards'),
                    subtitle: const Text('Practice and review study topics'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _choosePracticeTopic(
                      context,
                      title: 'Flash cards',
                      route: AppRoutes.flashCard,
                    ),
                  ),
                  Divider(color: context.colors.hairline),
                  ListTile(
                    leading: const Icon(Icons.quiz_rounded),
                    title: const Text('Quiz'),
                    subtitle: const Text('Test your understanding'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _choosePracticeTopic(
                      context,
                      title: 'Quiz',
                      route: AppRoutes.quiz,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _choosePracticeTopic(
    BuildContext context, {
    required String title,
    required String route,
  }) async {
    final selection = await showDialog<StudyPracticeSelection>(
      context: context,
      builder: (context) => _StudyPracticeDialog(title: title),
    );

    if (selection == null) {
      return;
    }

    Get.toNamed(route, arguments: selection);
  }
}

class _StudyPracticeDialog extends StatefulWidget {
  const _StudyPracticeDialog({required this.title});

  final String title;

  @override
  State<_StudyPracticeDialog> createState() => _StudyPracticeDialogState();
}

class _StudyPracticeDialogState extends State<_StudyPracticeDialog> {
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
      for (final topic in StudyScreen._topicsBySubject[_subject] ?? <String>[])
        MEDropdownOption(value: topic, label: topic),
    ];

    return AlertDialog(
      backgroundColor: isLightTheme
          ? colors.surfaceCard
          : colors.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MEDropdownField<String>(
                items: StudyScreen._subjectOptions,
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
      actions: [
        TextButton(
          onPressed: () => Get.back<StudyPracticeSelection>(),
          style: TextButton.styleFrom(foregroundColor: colors.primary),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _confirm, child: const Text('Confirm')),
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
