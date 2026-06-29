part of 'flash_card_result_container.dart';

class _FlashCardResultSummary extends StatelessWidget {
  const _FlashCardResultSummary({
    required this.correctCount,
    required this.cardCount,
    required this.progressPercent,
  });

  final int correctCount;
  final int cardCount;
  final double progressPercent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final summary = progressPercent >= 80
        ? 'Strong recall. Keep these cards warm with a quick later pass.'
        : progressPercent >= 50
        ? 'Good review. Spend a little time on the missed cards.'
        : 'This set needs another pass. Revisit the skipped and wrong cards.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.accentOrangeGlow.withValues(alpha: 0.28),
        borderRadius: AppRadius.button,
        border: Border.all(color: colors.accentOrange.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$correctCount correct out of $cardCount cards',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            summary,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.body),
          ),
        ],
      ),
    );
  }
}
