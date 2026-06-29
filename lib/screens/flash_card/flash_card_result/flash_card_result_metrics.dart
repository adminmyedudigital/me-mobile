part of 'flash_card_result_container.dart';

class _FlashCardResultMetrics extends StatelessWidget {
  const _FlashCardResultMetrics({
    required this.correctCount,
    required this.wrongCount,
    required this.skipCount,
  });

  final int correctCount;
  final int wrongCount;
  final int skipCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: _FlashCardResultMetricCard(
            icon: Icons.check_circle_rounded,
            label: 'Correct',
            value: correctCount.toString(),
            color: colors.accentGreen,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _FlashCardResultMetricCard(
            icon: Icons.cancel_rounded,
            label: 'Wrong',
            value: wrongCount.toString(),
            color: colors.accentRed,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _FlashCardResultMetricCard(
            icon: Icons.skip_next_rounded,
            label: 'Skip',
            value: skipCount.toString(),
            color: colors.accentBlue,
          ),
        ),
      ],
    );
  }
}
