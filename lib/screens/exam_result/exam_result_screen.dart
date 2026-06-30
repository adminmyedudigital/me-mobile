import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/controllers/controllers.dart';

class ExamResultScreen extends StatefulWidget {
  const ExamResultScreen({super.key});

  @override
  State<ExamResultScreen> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen> {
  final _formKey = GlobalKey<FormState>();

  late String? _subjectName;
  ExamType? _examType = ExamType.school;
  String _totalMarks = '';
  String _achievedMarks = '';

  ExamsController get _controller => Get.find<ExamsController>();

  @override
  void initState() {
    super.initState();
    _subjectName = _controller.subjects.firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Exam result')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xs,
            AppSpacing.xs,
            AppSpacing.xs,
            AppSpacing.band,
          ),
          children: [
            Container(
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
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
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        setState(() => _subjectName = value);
                      },
                      onSaved: (value) => _subjectName = value,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    MEDropdownField<ExamType>(
                      initialValue: _examType,
                      labelText: 'Exam type',
                      showClearButton: true,
                      prefixIcon: const Icon(Icons.school_outlined),
                      items: [
                        for (final type in ExamType.values)
                          MEDropdownOption(value: type, label: type.label),
                      ],
                      validator: _requiredDropdownValidator,
                      onChanged: (value) {
                        setState(() => _examType = value);
                      },
                      onSaved: (value) => _examType = value,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    METextField(
                      initialValue: _totalMarks,
                      labelText: 'Exam total marks',
                      prefixIcon: const Icon(Icons.fact_check_outlined),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                      validator: _totalMarksValidator,
                      onChanged: (value) => _totalMarks = value,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    METextField(
                      initialValue: _achievedMarks,
                      labelText: 'Achieved marks',
                      prefixIcon: const Icon(Icons.emoji_events_outlined),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.done,
                      validator: _achievedMarksValidator,
                      onChanged: (value) => _achievedMarks = value,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    MEButton(
                      fullWidth: true,
                      onPressed: _submit,
                      icon: Icons.save,
                      label: 'Save result',
                      backgroundColor: colors.primary,
                      foregroundColor: colors.surfaceCard,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();

    final selectedSubject = _subjectName;
    final selectedExamType = _examType;
    if (selectedSubject == null || selectedExamType == null) return;

    _controller.addExamResult(
      subjectName: selectedSubject,
      type: selectedExamType,
      totalMarks: int.parse(_totalMarks),
      achievedMarks: int.parse(_achievedMarks),
    );

    Get.back();
  }

  String? _totalMarksValidator(String? value) {
    final marks = int.tryParse((value ?? '').trim());
    if (marks == null) {
      return 'Total marks is required';
    }
    if (marks <= 0) {
      return 'Total marks must be greater than 0';
    }
    return null;
  }

  String? _achievedMarksValidator(String? value) {
    final marks = int.tryParse((value ?? '').trim());
    if (marks == null) {
      return 'Achieved marks is required';
    }
    if (marks < 0) {
      return 'Achieved marks cannot be negative';
    }

    final totalMarks = int.tryParse(_totalMarks.trim());
    if (totalMarks != null && marks > totalMarks) {
      return 'Achieved marks cannot exceed total marks';
    }
    return null;
  }
}

String? _requiredDropdownValidator<T>(T? value) {
  if (value == null) {
    return 'Required';
  }

  return null;
}
