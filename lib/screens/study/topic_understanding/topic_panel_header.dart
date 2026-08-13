import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_progress_indicator.dart';

class TopicPanelHeader extends StatelessWidget {
  const TopicPanelHeader({
    required this.topic,
    required this.topicIndex,
    required this.progress,
    required this.isExpanded,
    required this.colors,
    super.key,
  });

  final StudyTopicModel topic;
  final int topicIndex;
  final int progress;
  final bool isExpanded;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          TopicProgressIndicator(
            dimension: 42,
            progress: progress,
            colors: colors,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOPIC ${topicIndex + 1}  •  ${topic.subTopics.length} SUB TOPICS',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isExpanded ? colors.accentBlue : colors.mute,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  topic.label,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isExpanded ? colors.ink : colors.body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
