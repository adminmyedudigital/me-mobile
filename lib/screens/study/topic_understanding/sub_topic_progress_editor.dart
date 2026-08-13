import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:me_mobile/controllers/topic_understanding/topic_understanding.dart';
import 'package:me_mobile/screens/study/topic_understanding/animated_progress_ring.dart';
import 'package:me_mobile/screens/study/topic_understanding/progress_editor_context.dart';
import 'package:me_mobile/screens/study/topic_understanding/progress_slider_controls.dart';
import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/widgets.dart';

class SubTopicProgressEditor extends StatelessWidget {
  const SubTopicProgressEditor({required this.controller, super.key});

  final TopicUnderstandingProgressController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.canvas,
      child: SafeArea(
        child: GetBuilder<TopicUnderstandingProgressController>(
          id: TopicUnderstandingProgressController.editorUpdateId,
          builder: (controller) {
            final colors = context.colors;
            final topic = controller.editingTopic;
            final subTopic = controller.editingSubTopic;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Close',
                        onPressed: Navigator.of(context).pop,
                        icon: const Icon(Icons.close_rounded),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Update understanding',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: colors.hairline),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.sm,
                      AppSpacing.xl,
                      AppSpacing.xxl,
                    ),
                    child: Column(
                      children: [
                        ProgressEditorContext(
                          topic: topic,
                          subTopic: subTopic,
                          colors: colors,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AnimatedProgressRing(
                          progress: controller.editingProgress,
                          colors: colors,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Move the slider to reflect how well child understand this sub topic.',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        ProgressSliderControls(
                          controller: controller,
                          colors: colors,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    color: colors.canvas,
                    border: Border(
                      top: BorderSide(color: colors.hairlineStrong),
                    ),
                  ),
                  child: MEButton(
                    label: 'Save progress',
                    icon: Icons.check_rounded,
                    fullWidth: true,
                    backgroundColor: colors.primary,
                    foregroundColor: colors.primaryOn,
                    onPressed: () {
                      if (controller.saveEditingProgress()) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
