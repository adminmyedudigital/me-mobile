import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/screens/study/topic_understanding/progress_editor_context_item.dart';

class ProgressEditorContext extends StatelessWidget {
  const ProgressEditorContext({
    required this.topic,
    required this.subTopic,
    required this.colors,
    super.key,
  });

  final StudyTopicModel? topic;
  final StudySubTopicModel? subTopic;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProgressEditorContextItem(
          label: 'TOPIC',
          value: topic?.label ?? '',
          icon: Icons.topic_outlined,
          colors: colors,
        ),
        const SizedBox(height: AppSpacing.xs),
        Icon(Icons.keyboard_arrow_down_rounded, color: colors.mute, size: 24),
        const SizedBox(height: AppSpacing.xs),
        ProgressEditorContextItem(
          label: 'SUB TOPIC — UPDATING',
          value: subTopic?.label ?? '',
          icon: Icons.account_tree_outlined,
          colors: colors,
          highlighted: true,
        ),
      ],
    );
  }
}
