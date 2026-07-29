import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/controllers/study_controller.dart';
import 'package:me_mobile/screens/study/study_planning_subject/study_planning_subjects_dialog.dart';

class StudyPlanningSubjectSelector extends StatelessWidget {
  const StudyPlanningSubjectSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudyController>(
      id: StudyController.planningSubjectsUpdateId,
      builder: (controller) {
        final selectedSubjects = controller.selectedPlanningSubjects;
        final subtitle = selectedSubjects.isEmpty
            ? controller.errorMessage ??
                  'Select subjects to personalize study suggestions'
            : selectedSubjects
                  .map((subject) => subject.subjectLabel)
                  .join(', ');

        return ListTile(
          leading: const Icon(Icons.menu_book_rounded),
          title: const Text('Study planning subjects'),
          subtitle: Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: controller.isSavingPlanningSubjects
              ? const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.chevron_right),
          onTap: controller.hasSubjects && !controller.isSavingPlanningSubjects
              ? () {
                  controller.preparePlanningSubjectsDialog();
                  showDialog<void>(
                    context: context,
                    builder: (context) => const StudyPlanningSubjectsDialog(),
                  );
                }
              : null,
        );
      },
    );
  }
}
