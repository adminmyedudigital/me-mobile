import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/controllers/study_controller.dart';

class StudyPlanningSubjectsDialog extends StatelessWidget {
  const StudyPlanningSubjectsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudyController>(
      id: StudyController.planningSubjectsDialogUpdateId,
      builder: (controller) {
        final colors = context.colors;
        final isLightTheme = Theme.of(context).brightness == Brightness.light;

        return AlertDialog(
          backgroundColor: isLightTheme
              ? colors.surfaceCard
              : colors.surfaceElevated,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
          title: const Text('Study planning subjects'),
          content: SizedBox(
            width: 320,
            child: ListView(
              shrinkWrap: true,
              children: [
                CheckboxListTile(
                  value: controller.areAllPlanningSubjectsSelected,
                  title: const Text('Select all'),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) =>
                      controller.toggleAllPlanningSubjects(value == true),
                ),
                Divider(color: colors.hairline),
                for (final subject in controller.subjects)
                  CheckboxListTile(
                    value: controller.draftPlanningSubjectIds.contains(
                      subject.id,
                    ),
                    title: Text(subject.subjectLabel),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) => controller.togglePlanningSubject(
                      subject.id,
                      value == true,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            MEButton(
              label: 'Cancel',
              fullWidth: true,
              backgroundColor: colors.primaryOn,
              foregroundColor: colors.ink,
              onPressed: Get.back<void>,
            ),
            const SizedBox(height: AppSpacing.sm),
            MEButton(
              label: 'Done',
              fullWidth: true,
              backgroundColor: colors.primary,
              foregroundColor: colors.primaryOn,
              onPressed: () {
                controller.savePlanningSubjects();
                Get.back<void>();
              },
            ),
          ],
        );
      },
    );
  }
}
