import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';

class FlashCardContainer extends StatelessWidget {
  const FlashCardContainer({super.key});

  void _handleBack() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: _handleBack),
          title: const Text('Flashcards'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: colors.surfaceDeep.withValues(alpha: 0.78),
                borderRadius: AppRadius.card,
                border: Border.all(color: colors.hairline),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.style_rounded,
                    color: colors.accentOrange,
                    size: 32,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Flashcards',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.ink,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Flashcard screen content will be added here.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: colors.charcoal),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
