import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_empty_state.dart';

class TopicSubjectEmptyState extends StatelessWidget {
  const TopicSubjectEmptyState({required this.colors, super.key});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return TopicEmptyState(
      colors: colors,
      icon: Icons.touch_app_outlined,
      title: 'No subject selected',
      message: 'Select a subject above to view its topics and sub topics.',
    );
  }
}
