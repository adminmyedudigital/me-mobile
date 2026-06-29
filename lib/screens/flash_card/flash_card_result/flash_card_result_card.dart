part of 'flash_card_result_container.dart';

class _FlashCardResultCard extends StatelessWidget {
  const _FlashCardResultCard({
    required this.correctCount,
    required this.wrongCount,
    required this.skipCount,
    required this.cardCount,
    required this.progressPercent,
  });

  final int correctCount;
  final int wrongCount;
  final int skipCount;
  final int cardCount;
  final double progressPercent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isLightTheme
            ? colors.surfaceCard
            : colors.surfaceElevated.withValues(alpha: 0.78),
        borderRadius: AppRadius.card,
        border: Border.all(
          color: colors.accentOrange.withValues(
            alpha: isLightTheme ? 0.18 : 0.28,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.accentOrangeGlow.withValues(
              alpha: isLightTheme ? 0.1 : 0.18,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FlashCardResultHeader(),
          const SizedBox(height: AppSpacing.xl),
          Center(child: _FlashCardScoreRing(progressPercent: progressPercent)),
          const SizedBox(height: AppSpacing.xl),
          _FlashCardResultMetrics(
            correctCount: correctCount,
            wrongCount: wrongCount,
            skipCount: skipCount,
          ),
          const SizedBox(height: AppSpacing.lg),
          _FlashCardResultSummary(
            correctCount: correctCount,
            cardCount: cardCount,
            progressPercent: progressPercent,
          ),
        ],
      ),
    );
  }
}
