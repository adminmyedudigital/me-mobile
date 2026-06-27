import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:me_mobile/controllers/controllers.dart';
import 'package:me_mobile/theme/theme.dart';

class ExamsTabContainer extends StatelessWidget {
  const ExamsTabContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExamsController>();

    return Obx(
      () => ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xs,
          AppSpacing.xs,
          AppSpacing.xs,
          AppSpacing.band,
        ),
        children: [
          for (final exam in controller.sortedExams) ...[
            _ExamCard(
              exam: exam,
              dateLabel: controller.formatDate(exam.examDate),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  const _ExamCard({required this.exam, required this.dateLabel});

  final ExamItem exam;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final accentColor = switch (exam.type) {
      ExamType.school => context.colors.accentBlue,
      ExamType.tuition => context.colors.accentGreen,
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: context.colors.ink,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        dateLabel,
                        style: Theme.of(context).textTheme.bodySmall,
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
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: AppSpacing.xxs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: context.colors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (helper != null) ...[
                  const SizedBox(width: AppSpacing.xxs),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
                    child: Text(
                      helper!,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
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
