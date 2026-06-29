import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class FlashCardFace extends StatelessWidget {
  const FlashCardFace({
    super.key,
    required this.label,
    required this.icon,
    required this.title,
    required this.alertText,
    required this.body,
    required this.actionText,
    required this.currentIndex,
    required this.cardCount,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final String title;
  final String alertText;
  final String body;
  final String actionText;
  final int currentIndex;
  final int cardCount;
  final VoidCallback onPressed;

  void _showBodyDialog(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isLightTheme
              ? colors.surfaceCard
              : colors.surfaceElevated,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.card,
            side: BorderSide(
              color: colors.accentOrange.withValues(
                alpha: isLightTheme ? 0.16 : 0.24,
              ),
            ),
          ),
          title: Text(
            alertText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              body,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.body),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: colors.accentOrange),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final foregroundColor = colors.primary;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.65,
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
          Row(
            children: [
              Expanded(
                child: Text(
                  '${currentIndex + 1} / $cardCount',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.charcoal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                tooltip: label,
                onPressed: body.isEmpty ? null : () => _showBodyDialog(context),
                icon: Icon(icon),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: foregroundColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(foregroundColor: colors.accentOrange),
              onPressed: onPressed,
              child: Text(actionText),
            ),
          ),
        ],
      ),
    );
  }
}
