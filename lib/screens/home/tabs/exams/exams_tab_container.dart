import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class ExamsTabContainer extends StatelessWidget {
  const ExamsTabContainer({super.key});

  static final _exams = [
    _ExamItem(
      subjectName: 'English',
      examDate: DateTime(2026, 7, 4),
      type: _ExamType.school,
      totalMarks: 100,
      achievedMarks: 86,
    ),
    _ExamItem(
      subjectName: 'Mathematics',
      examDate: DateTime(2026, 7, 2),
      type: _ExamType.tuition,
      totalMarks: 80,
      achievedMarks: 72,
    ),
    _ExamItem(
      subjectName: 'Science',
      examDate: DateTime(2026, 6, 29),
      type: _ExamType.school,
      totalMarks: 100,
      achievedMarks: 91,
    ),
    _ExamItem(
      subjectName: 'Social Studies',
      examDate: DateTime(2026, 6, 24),
      type: _ExamType.tuition,
      totalMarks: 50,
      achievedMarks: 41,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final exams = List<_ExamItem>.of(_exams)
      ..sort((first, second) => second.examDate.compareTo(first.examDate));

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.band,
      ),
      children: [
        for (final exam in exams) ...[
          _ExamCard(exam: exam),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

enum _ExamType {
  school('School'),
  tuition('Tuition');

  const _ExamType(this.label);

  final String label;
}

class _ExamItem {
  const _ExamItem({
    required this.subjectName,
    required this.examDate,
    required this.type,
    required this.totalMarks,
    required this.achievedMarks,
  });

  final String subjectName;
  final DateTime examDate;
  final _ExamType type;
  final int totalMarks;
  final int achievedMarks;

  int get scorePercent => ((achievedMarks / totalMarks) * 100).round();
}

class _ExamCard extends StatelessWidget {
  const _ExamCard({required this.exam});

  final _ExamItem exam;

  @override
  Widget build(BuildContext context) {
    final accentColor = switch (exam.type) {
      _ExamType.school => context.colors.accentBlue,
      _ExamType.tuition => context.colors.accentGreen,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${exam.subjectName} exam ${exam.subjectName} exam ${exam.subjectName} exam ${exam.subjectName} exam ${exam.subjectName} exam ${exam.subjectName} exam ${exam.subjectName} exam ${exam.subjectName} exam',
                        maxLines: 1,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _formatDate(exam.examDate),
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                _ExamTypeChip(label: exam.type.label, color: accentColor),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: _ExamMetric(
                    label: 'Total marks',
                    value: exam.totalMarks.toString(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _ExamMetric(
                    label: 'Achieved marks',
                    value: '${exam.achievedMarks} / ${exam.totalMarks}',
                    helper: '${exam.scorePercent}%',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _ExamTypeChip extends StatelessWidget {
  const _ExamTypeChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.36)),
        borderRadius: AppRadius.pill,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ExamMetric extends StatelessWidget {
  const _ExamMetric({required this.label, required this.value, this.helper});

  final String label;
  final String value;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceElevated,
        border: Border.all(color: context.colors.hairline),
        borderRadius: AppRadius.input,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: context.textTheme.labelSmall),
            const SizedBox(height: AppSpacing.xxs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: context.colors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (helper != null) ...[
                  const SizedBox(width: AppSpacing.xxs),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
                    child: Text(helper!, style: context.textTheme.labelSmall),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
