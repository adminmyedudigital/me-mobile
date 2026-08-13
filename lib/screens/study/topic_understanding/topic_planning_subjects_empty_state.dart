import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/study/topic_understanding/topic_empty_state.dart';

class TopicPlanningSubjectsEmptyState extends StatelessWidget {
  const TopicPlanningSubjectsEmptyState({required this.colors, super.key});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return TopicEmptyState(
      colors: colors,
      icon: Icons.playlist_add_check_rounded,
      title: 'No study planning subjects',
      message: 'Select subjects in Study planning subjects to view them here.',
    );
  }
}
