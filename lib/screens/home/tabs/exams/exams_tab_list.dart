import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/screens/screens.dart';

class ExamsTabList extends StatelessWidget {
  const ExamsTabList({
    super.key,
    required this.exams,
    required this.dateFormatter,
  });

  final List<ExamModel> exams;
  final String Function(DateTime date) dateFormatter;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.band,
      ),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        return ExamsTabCard(
          exam: exam,
          dateLabel: dateFormatter(exam.examDate),
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
    );
  }
}
