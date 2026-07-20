import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/controllers/study_controller.dart';

class StudyPracticeDialog extends StatelessWidget {
  const StudyPracticeDialog({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudyController>(
      id: StudyController.practiceDialogUpdateId,
      builder: (controller) {
        final colors = context.colors;
        final isLightTheme = Theme.of(context).brightness == Brightness.light;
        final subjectOptions = controller.subjects
            .map(
              (subject) => MEDropdownOption(
                value: subject.id,
                label: subject.subjectLabel,
              ),
            )
            .toList();
        final topicOptions = controller.topicsForSelectedSubject
            .map(
              (topic) => MEDropdownOption(value: topic.id, label: topic.label),
            )
            .toList();

        return AlertDialog(
          backgroundColor: isLightTheme
              ? colors.surfaceCard
              : colors.surfaceElevated,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
          title: Text(title),
          content: SizedBox(
            width: 320,
            child: Form(
              key: controller.practiceFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MEDropdownField<String>(
                      items: subjectOptions,
                      initialValue: controller.selectedSubjectId,
                      labelText: 'Subject',
                      hintText: 'Select Subject',
                      prefixIcon: const Icon(Icons.menu_book_outlined),
                      autovalidateMode: controller.practiceAutovalidateMode,
                      validator: controller.requiredSelection('Subject'),
                      onChanged: controller.selectSubject,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    MEDropdownField<String>(
                      key: ValueKey(controller.selectedSubjectId),
                      items: topicOptions,
                      initialValue: controller.selectedTopicId,
                      labelText: 'Topic',
                      hintText: 'Select Topic',
                      prefixIcon: const Icon(Icons.topic_outlined),
                      autovalidateMode: controller.practiceAutovalidateMode,
                      validator: controller.requiredSelection('Topic'),
                      onChanged: controller.selectTopic,
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
              onPressed: () {
                final selection = controller.submitPracticeSelection();
                if (selection != null) {
                  Get.back(result: selection);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
