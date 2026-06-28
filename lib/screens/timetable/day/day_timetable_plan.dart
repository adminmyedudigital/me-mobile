import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/controllers/dashboard_controller.dart';
import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/theme/theme.dart';

class DayTimetablePlan extends StatefulWidget {
  const DayTimetablePlan({super.key, required this.event});

  final DashboardEvent event;

  @override
  State<DayTimetablePlan> createState() => _DayTimetablePlanState();
}

class _DayTimetablePlanState extends State<DayTimetablePlan> {
  bool _isCompleted = false;

  void _openFlashcards() {
    Get.toNamed(AppRoutes.flashCard);
  }

  void _openQuiz() {}

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isLightTheme
            ? colors.surfaceDeep
            : colors.surfaceElevated.withValues(alpha: 0.72),
        borderRadius: AppRadius.card,
        border: Border.all(
          color: isLightTheme ? colors.hairline : colors.hairlineStrong,
        ),
        boxShadow: [
          if (isLightTheme)
            BoxShadow(
              color: colors.canvas.withValues(alpha: 0.58),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CompletionTile(
            isCompleted: _isCompleted,
            onChanged: (value) {
              setState(() {
                _isCompleted = value;
              });
            },
          ),
          Row(
            children: [
              Expanded(
                child: _PlanActionTile(
                  icon: Icons.style_rounded,
                  title: 'Flashcards',
                  subtitle: 'Review key cards',
                  onTap: _openFlashcards,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _PlanActionTile(
                  icon: Icons.quiz_rounded,
                  title: 'Quiz',
                  subtitle: 'Practice questions',
                  onTap: _openQuiz,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _SummaryBlock(event: widget.event),
        ],
      ),
    );
  }
}

class _CompletionTile extends StatelessWidget {
  const _CompletionTile({required this.isCompleted, required this.onChanged});

  final bool isCompleted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      borderRadius: AppRadius.button,
      onTap: () => onChanged(!isCompleted),
      child: Row(
        children: [
          Checkbox(
            value: isCompleted,
            activeColor: colors.accentGreen,
            onChanged: (value) => onChanged(value ?? false),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              isCompleted ? 'Study completed' : 'Mark study completed',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.ink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryBlock extends StatelessWidget {
  const _SummaryBlock({required this.event});

  final DashboardEvent event;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.ink,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Study summary will appear here with key points, progress notes, and reminders for ${event.timeLabel}.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.charcoal,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanActionTile extends StatelessWidget {
  const _PlanActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      borderRadius: AppRadius.button,
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 92),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.accentOrange.withValues(alpha: 0.08),
          borderRadius: AppRadius.button,
          border: Border.all(
            color: colors.accentOrange.withValues(alpha: 0.18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colors.accentOrange, size: 22),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colors.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.charcoal,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
