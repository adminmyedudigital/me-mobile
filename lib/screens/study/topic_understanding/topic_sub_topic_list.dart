import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/controllers/topic_understanding_controller.dart';
import 'package:me_mobile/screens/study/topic_understanding/sub_topic_tile.dart';
import 'package:me_mobile/screens/study/topic_understanding/sub_topic_section_label.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_progress_indicator.dart';

class TopicSubTopicList extends StatelessWidget {
  const TopicSubTopicList({
    required this.controller,
    required this.topic,
    required this.topicIndex,
    required this.colors,
    super.key,
  });

  final TopicUnderstandingController controller;
  final StudyTopicModel topic;
  final int topicIndex;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceDeep,
        border: Border(top: BorderSide(color: colors.hairlineStrong)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SubTopicSectionLabel(colors: colors),
          const SizedBox(height: AppSpacing.md),
          if (topic.subTopics.isEmpty)
            Text(
              'No sub topics available.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.start,
            )
          else
            for (var index = 0; index < topic.subTopics.length; index++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: index == topic.subTopics.length - 1
                      ? 0
                      : AppSpacing.sm,
                ),
                child: SubTopicTile(
                  controller: controller,
                  topic: topic,
                  subTopic: topic.subTopics[index],
                  progress: TopicProgressSamples.subTopic(topicIndex, index),
                  colors: colors,
                ),
              ),
        ],
      ),
    );
  }
}
