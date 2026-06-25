import 'package:flutter/material.dart';
// import 'package:me_mobile/screens/home/tabs/dashboard/progress_card/progress_card.dart';
import 'package:me_mobile/theme/theme.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  static const _quizOptions = [
    'By factoring, completing square, or formula',
    'Only by multiplying the coefficients',
    'Only by adding both roots first',
  ];
  static const _correctAnswerIndex = 0;

  bool _targetCompleted = false;
  bool _notesReviewed = false;
  int? _selectedAnswerIndex;

  double get _topicProgress {
    final quizScore = _selectedAnswerIndex == null
        ? 0.0
        : _selectedAnswerIndex == _correctAnswerIndex
        ? 0.40
        : 0.12;

    return ((_targetCompleted ? 0.35 : 0.0) +
            (_notesReviewed ? 0.25 : 0.0) +
            quizScore)
        .clamp(0.0, 1.0);
  }

  int get _topicProgressPercent => (_topicProgress * 100).round();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.band,
      ),
      children: [
        // const ProgressCard(),
        const SizedBox(height: AppSpacing.lg),
        _TodayTargetCard(
          targetCompleted: _targetCompleted,
          notesReviewed: _notesReviewed,
          selectedAnswerIndex: _selectedAnswerIndex,
          topicProgressPercent: _topicProgressPercent,
          onTargetChanged: (value) {
            setState(() => _targetCompleted = value ?? false);
          },
          onNotesChanged: (value) {
            setState(() => _notesReviewed = value ?? false);
          },
          onAnswerSelected: (index) {
            setState(() => _selectedAnswerIndex = index);
          },
        ),
      ],
    );
  }
}

class _TodayTargetCard extends StatelessWidget {
  const _TodayTargetCard({
    required this.targetCompleted,
    required this.notesReviewed,
    required this.selectedAnswerIndex,
    required this.topicProgressPercent,
    required this.onTargetChanged,
    required this.onNotesChanged,
    required this.onAnswerSelected,
  });

  final bool targetCompleted;
  final bool notesReviewed;
  final int? selectedAnswerIndex;
  final int topicProgressPercent;
  final ValueChanged<bool?> onTargetChanged;
  final ValueChanged<bool?> onNotesChanged;
  final ValueChanged<int> onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    final answered = selectedAnswerIndex != null;
    final correct =
        selectedAnswerIndex == _DashboardTabState._correctAnswerIndex;

    return _DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.today, color: context.colors.accentOrange),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Today study target',
                  style: context.textTheme.titleLarge,
                ),
              ),
              Text(
                '$topicProgressPercent%',
                style: context.textTheme.headlineSmall?.copyWith(
                  color: context.colors.accentGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _TargetInfoRow(
            icon: Icons.menu_book_outlined,
            label: 'Subject',
            value: 'Mathematics',
          ),
          const SizedBox(height: AppSpacing.md),
          _TargetInfoRow(
            icon: Icons.lightbulb_outline,
            label: 'Topic',
            value: 'Quadratic equations',
          ),
          const SizedBox(height: AppSpacing.xl),
          _StudyChecklistTile(
            value: targetCompleted,
            title: 'Completed today study',
            subtitle: 'Mark after finishing the topic lesson.',
            onChanged: onTargetChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          _StudyChecklistTile(
            value: notesReviewed,
            title: 'Reviewed study notes',
            subtitle: 'Confirm after reading notes once again.',
            onChanged: onNotesChanged,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Quick quiz', style: context.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'How can a student find the roots of a quadratic equation?',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          for (
            var index = 0;
            index < _DashboardTabState._quizOptions.length;
            index++
          )
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _QuizOptionButton(
                label: _DashboardTabState._quizOptions[index],
                selected: selectedAnswerIndex == index,
                correct: index == _DashboardTabState._correctAnswerIndex,
                onTap: () => onAnswerSelected(index),
              ),
            ),
          if (answered) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              correct
                  ? 'Correct. Topic understanding is improving.'
                  : 'Review the notes once more, then try the method step by step.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: correct
                    ? context.colors.accentGreen
                    : context.colors.accentYellow,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DashboardPanel extends StatelessWidget {
  const _DashboardPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceCard,
        borderRadius: AppRadius.card,
        border: Border.all(color: context.colors.hairline),
        boxShadow: [
          BoxShadow(
            color: context.colors.accentRedGlow.withAlpha(24),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(padding: AppSpacing.card, child: child),
    );
  }
}

class _TargetInfoRow extends StatelessWidget {
  const _TargetInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: context.colors.accentBlue, size: 22),
        const SizedBox(width: AppSpacing.md),
        Text('$label: ', style: context.textTheme.bodySmall),
        Expanded(
          child: Text(
            value,
            style: context.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StudyChecklistTile extends StatelessWidget {
  const _StudyChecklistTile({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  final bool value;
  final String title;
  final String subtitle;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.card,
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colors.surfaceElevated.withAlpha(140),
          borderRadius: AppRadius.card,
          border: Border.all(color: context.colors.hairline),
        ),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: context.colors.accentGreen,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(subtitle, style: context.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizOptionButton extends StatelessWidget {
  const _QuizOptionButton({
    required this.label,
    required this.selected,
    required this.correct,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool correct;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? correct
              ? context.colors.accentGreen
              : context.colors.accentYellow
        : context.colors.hairline;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.card,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: selected
                ? context.colors.surfaceElevated
                : context.colors.surfaceDeep,
            borderRadius: AppRadius.card,
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? correct
                          ? Icons.check_circle
                          : Icons.error_outline
                    : Icons.radio_button_unchecked,
                color: selected
                    ? correct
                          ? context.colors.accentGreen
                          : context.colors.accentYellow
                    : context.colors.charcoal,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(label, style: context.textTheme.bodyMedium)),
            ],
          ),
        ),
      ),
    );
  }
}
