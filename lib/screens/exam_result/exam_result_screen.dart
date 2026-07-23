import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/controllers/controllers.dart';

class ExamResultScreen extends StatefulWidget {
  const ExamResultScreen({super.key});

  @override
  State<ExamResultScreen> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen> {
  ExamsController get _controller => Get.find<ExamsController>();

  @override
  void initState() {
    super.initState();
    _controller.prepareResultForm();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Obx(() {
      final isSubmitting = _controller.isSubmittingExam.value;

      return PopScope(
        canPop: !isSubmitting,
        child: Scaffold(
          appBar: AppBar(title: const Text('Exam result')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.sm,
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
                  child: GetBuilder<ExamsController>(
                    id: ExamsController.resultFormUpdateId,
                    builder: (controller) {
                      final topicOptions = controller.topicsForSelectedSubject
                          .map(
                            (topic) => MEDropdownOption(
                              value: topic.id,
                              label: topic.label,
                            ),
                          )
                          .toList();

                      return Form(
                        key: controller.examResultFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_controller.subjectsErrorMessage
                                case final message?) ...[
                              Text(
                                message,
                                style: TextStyle(color: colors.accentRed),
                              ),
                              const SizedBox(height: AppSpacing.md),
                            ],
                            MEDropdownField<String>(
                              initialValue: controller.selectedSubjectId,
                              labelText: 'Subject',
                              showClearButton: true,
                              prefixIcon: const Icon(Icons.menu_book_outlined),
                              items: [
                                for (final subject in _controller.subjects)
                                  MEDropdownOption(
                                    value: subject.id,
                                    label: subject.label,
                                  ),
                              ],
                              validator: controller.validateSubject,
                              onChanged: controller.selectSubject,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            MEMultiSelectDropdownField<String>(
                              key: ValueKey(controller.selectedSubjectId),
                              items: topicOptions,
                              initialValue: controller.selectedTopicIds,
                              labelText: 'Topics',
                              hintText: controller.selectedSubjectId == null
                                  ? 'Select a subject first'
                                  : 'Select topics',
                              prefixIcon: const Icon(Icons.topic_outlined),
                              enabled: controller.selectedSubjectId != null,
                              validator: controller.validateTopics,
                              onChanged: controller.selectTopics,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            MEDropdownField<ExamType>(
                              initialValue: controller.selectedExamType,
                              labelText: 'Exam type',
                              showClearButton: true,
                              prefixIcon: const Icon(Icons.school_outlined),
                              items: [
                                for (final type in ExamType.values)
                                  MEDropdownOption(
                                    value: type,
                                    label: type.label,
                                  ),
                              ],
                              validator: controller.validateExamType,
                              onChanged: controller.selectExamType,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            MEDatePickerField(
                              value: controller.selectedExamDate,
                              initialDate: controller.today,
                              firstDate: controller.earliestExamDate,
                              lastDate: controller.today,
                              labelText: 'Exam date',
                              displayValue: controller.selectedExamDateLabel,
                              prefixIcon: const Icon(Icons.event_outlined),
                              validator: controller.validateExamDate,
                              onChanged: controller.selectExamDate,
                              onCleared: () => controller.selectExamDate(null),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            METextField(
                              initialValue: controller.totalMarks,
                              labelText: 'Exam total marks',
                              prefixIcon: const Icon(Icons.fact_check_outlined),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              textInputAction: TextInputAction.next,
                              validator: controller.validateTotalMarks,
                              onChanged: controller.setTotalMarks,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            METextField(
                              initialValue: controller.achievedMarks,
                              labelText: 'Achieved marks',
                              prefixIcon: const Icon(
                                Icons.emoji_events_outlined,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              textInputAction: TextInputAction.done,
                              validator: controller.validateAchievedMarks,
                              onChanged: controller.setAchievedMarks,
                              onFieldSubmitted: (_) => _submit(),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            MEButton(
                              fullWidth: true,
                              onPressed: _submit,
                              isLoading: isSubmitting,
                              icon: Icons.save,
                              label: controller.submitButtonLabel,
                              backgroundColor: colors.primary,
                              foregroundColor: colors.surfaceCard,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> _submit() async {
    final didSubmit = await _controller.submitExamResult();
    if (didSubmit && mounted) {
      Get.back();
    }
  }
}
