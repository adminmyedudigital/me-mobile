part of 'flash_card_result_container.dart';

class _FlashCardResultHeader extends StatelessWidget {
  const _FlashCardResultHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flashcard result',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.charcoal,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Here is how this review round went.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colors.body),
        ),
      ],
    );
  }
}
