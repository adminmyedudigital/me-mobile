import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_empty_state.dart';

class TopicListEmptyState extends StatelessWidget {
  const TopicListEmptyState({required this.colors, super.key});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return TopicEmptyState(
      colors: colors,
      icon: Icons.topic_outlined,
      title: 'No topics available',
      message: 'There are no topics available for this subject yet.',
    );
  }
}
