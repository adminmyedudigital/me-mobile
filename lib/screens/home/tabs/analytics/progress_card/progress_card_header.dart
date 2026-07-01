import 'package:flutter/material.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/progress_dots.dart';
import 'package:me_mobile/theme/theme.dart';

class ProgressCardHeader extends StatelessWidget {
  const ProgressCardHeader({
    super.key,
    required this.title,
    required this.currentTitle,
    required this.slideCount,
    required this.currentSlide,
  });

  final String title;
  final String currentTitle;
  final int slideCount;
  final int currentSlide;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.12),
            borderRadius: AppRadius.button,
            border: Border.all(
              color: context.colors.primary.withValues(alpha: 0.36),
            ),
          ),
          child: Icon(Icons.insights, color: context.colors.primary, size: 18),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colors.ink,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                currentTitle,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colors.ink,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        ProgressDots(
          count: slideCount,
          currentIndex: currentSlide,
          color: context.colors.primary,
        ),
      ],
    );
  }
}
