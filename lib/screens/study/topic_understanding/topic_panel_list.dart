import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/controllers/topic_understanding/topic_understanding.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_panel_header.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_sub_topic_list.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_section_header.dart';

class TopicPanelList extends StatelessWidget {
  const TopicPanelList({
    required this.controller,
    required this.progressController,
    required this.subject,
    required this.colors,
    super.key,
  });

  final TopicUnderstandingController controller;
  final TopicUnderstandingProgressController progressController;
  final StudySubjectTopicsModel subject;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final topics = subject.topics;

    return Column(
      children: [
        TopicSectionHeader(topicCount: topics.length, colors: colors),
        const SizedBox(height: AppSpacing.md),
        ClipRRect(
          borderRadius: AppRadius.card,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: colors.hairlineStrong),
              borderRadius: AppRadius.card,
            ),
            child: ExpansionPanelList(
              elevation: 0,
              expandedHeaderPadding: EdgeInsets.zero,
              materialGapSize: 0,
              dividerColor: colors.hairlineStrong,
              expansionCallback: (index, isExpanded) {
                controller.setTopicExpanded(topics[index], isExpanded);
              },
              children: [
                for (var index = 0; index < topics.length; index++)
                  ExpansionPanel(
                    backgroundColor: colors.surfaceCard,
                    canTapOnHeader: true,
                    isExpanded: controller.isTopicExpanded(topics[index]),
                    headerBuilder: (context, isExpanded) => TopicPanelHeader(
                      topic: topics[index],
                      topicIndex: index,
                      progress: progressController.topicProgress(
                        topics[index],
                        index,
                      ),
                      isExpanded: isExpanded,
                      colors: colors,
                    ),
                    body: TopicSubTopicList(
                      controller: controller,
                      progressController: progressController,
                      topic: topics[index],
                      topicIndex: index,
                      colors: colors,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
