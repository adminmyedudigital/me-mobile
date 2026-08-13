import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/widgets.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_panel_list.dart';
import 'package:me_mobile/controllers/topic_understanding/topic_understanding.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_list_empty_state.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_subject_empty_state.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_planning_subjects_empty_state.dart';

class TopicUnderstandingContent extends StatelessWidget {
  const TopicUnderstandingContent({
    required this.controller,
    required this.progressController,
    super.key,
  });

  final TopicUnderstandingController controller;
  final TopicUnderstandingProgressController progressController;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedSubject = controller.selectedSubject;
    final planningSubjects = controller.planningSubjects;
    final subjectOptions = planningSubjects
        .map(
          (subject) =>
              MEDropdownOption(value: subject.id, label: subject.subjectLabel),
        )
        .toList(growable: false);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.band,
      ),
      children: [
        Card(
          color: colors.surfaceElevated,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.errorMessage case final message?) ...[
                  Text(
                    message,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: colors.accentRed),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                MEDropdownField<String>(
                  items: subjectOptions,
                  initialValue: controller.selectedSubjectId,
                  labelText: 'Subject',
                  hintText: 'Select Subject',
                  prefixIcon: const Icon(Icons.menu_book_outlined),
                  enabled: planningSubjects.isNotEmpty,
                  onChanged: controller.selectSubject,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (planningSubjects.isEmpty)
                  TopicPlanningSubjectsEmptyState(colors: colors)
                else if (selectedSubject == null)
                  TopicSubjectEmptyState(colors: colors)
                else if (selectedSubject.topics.isEmpty)
                  TopicListEmptyState(colors: colors)
                else
                  TopicPanelList(
                    key: ValueKey(selectedSubject.id),
                    controller: controller,
                    progressController: progressController,
                    subject: selectedSubject,
                    colors: colors,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
