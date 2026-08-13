import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/controllers/topic_understanding_controller.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_progress_indicator.dart';

class SubTopicTile extends StatelessWidget {
  const SubTopicTile({
    required this.controller,
    required this.topic,
    required this.subTopic,
    required this.progress,
    required this.colors,
    super.key,
  });

  final TopicUnderstandingController controller;
  final StudyTopicModel topic;
  final StudySubTopicModel subTopic;
  final int progress;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final isSelected = controller.selectedSubTopicId == subTopic.id;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? colors.accentBlueGlow : colors.surfaceElevated,
        borderRadius: AppRadius.button,
        border: Border.all(
          color: isSelected ? colors.accentBlue : colors.hairlineStrong,
        ),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.sm,
        ),
        minLeadingWidth: 0,
        horizontalTitleGap: AppSpacing.sm,
        title: Text(
          subTopic.label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
        trailing: TopicProgressIndicator(progress: progress, colors: colors),
        selected: isSelected,
        selectedColor: colors.accentBlue,
        onTap: () => controller.selectSubTopic(topic, subTopic),
      ),
    );
  }
}
