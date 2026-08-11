import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/controllers/study_controller.dart';
import 'package:me_mobile/controllers/exam/exams_controller.dart';
import 'package:me_mobile/screens/study/study_practice_dialog.dart';
import 'package:me_mobile/screens/study/study_planning_subject/study_planning_subject.dart';

class StudyScreenContent extends GetView<StudyController> {
  const StudyScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final unavailableMessage = controller.errorMessage;

    return SafeArea(
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
                    'Setup your academic year, education board and class',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Get.toNamed<void>(AppRoutes.academicSetup);
                    await controller.loadSubjectTopics();
                  },
                ),
                Divider(color: context.colors.hairline),
                const StudyPlanningSubjectSelector(),
                Divider(color: context.colors.hairline),
                ListTile(
                  leading: const Icon(Icons.psychology_alt_outlined),
                  title: const Text('Topic understanding'),
                  subtitle: Text(
                    unavailableMessage ??
                        'Assess your understanding by subject and topic',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: controller.hasSubjects
                      ? () => _choosePracticeTopic(
                          context,
                          title: 'Topic understanding',
                          route: AppRoutes.quiz,
                        )
                      : null,
                ),
                Divider(color: context.colors.hairline),
                ListTile(
                  leading: const Icon(Icons.trending_up_rounded),
                  title: const Text('School & tuition progress'),
                  subtitle: Text(
                    unavailableMessage ??
                        'Update subject and topic performance from exams',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: controller.hasSubjects
                      ? _openSchoolTuitionProgress
                      : null,
                ),
                Divider(color: context.colors.hairline),
                ListTile(
                  leading: const Icon(Icons.style_rounded),
                  title: const Text('Flash cards'),
                  subtitle: Text(
                    unavailableMessage ?? 'Practice and review study topics',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: controller.hasSubjects
                      ? () => _choosePracticeTopic(
                          context,
                          title: 'Flash cards',
                          route: AppRoutes.flashCard,
                        )
                      : null,
                ),
                Divider(color: context.colors.hairline),
                ListTile(
                  leading: const Icon(Icons.quiz_rounded),
                  title: const Text('Quiz'),
                  subtitle: Text(
                    unavailableMessage ?? 'Test your understanding',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: controller.hasSubjects
                      ? () => _choosePracticeTopic(
                          context,
                          title: 'Quiz',
                          route: AppRoutes.quiz,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _choosePracticeTopic(
    BuildContext context, {
    required String title,
    required String route,
  }) async {
    controller.preparePracticeDialog();
    final selection = await showDialog<StudyPracticeSelection>(
      context: context,
      builder: (context) => StudyPracticeDialog(title: title),
    );

    if (selection == null) {
      return;
    }

    Get.toNamed(route, arguments: selection);
  }

  Future<void> _openSchoolTuitionProgress() async {
    final examsController = Get.find<ExamsController>();
    if (examsController.isApiOperationInProgress) {
      return;
    }

    await examsController.loadSubjectTopics();
    Get.toNamed(AppRoutes.examResult);
  }
}
