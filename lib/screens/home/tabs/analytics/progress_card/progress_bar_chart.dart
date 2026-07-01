import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/study_progress_summary.dart';
import 'package:me_mobile/theme/theme.dart';

class ProgressBarChart extends StatelessWidget {
  const ProgressBarChart({super.key, required this.title, required this.items});

  final String title;
  final List<ProgressBarChartData> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartHeight =
            constraints.hasBoundedHeight &&
                constraints.maxHeight > _minimumChartHeight
            ? constraints.maxHeight
            : _minimumChartHeight;

        return SizedBox(
          height: chartHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: AppRadius.button,
              border: Border.all(color: colors.hairline),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: colors.ink,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: items.isEmpty
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'No progress data',
                              style: context.textTheme.bodySmall,
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final chartWidth = math.max(
                                constraints.maxWidth,
                                items.length * 72,
                              );

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: chartWidth.toDouble(),
                                  child: Stack(
                                    children: [
                                      const _ProgressBarChartGrid(),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          for (
                                            var index = 0;
                                            index < items.length;
                                            index++
                                          )
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: index == 0
                                                      ? 0
                                                      : AppSpacing.xs,
                                                  right:
                                                      index == items.length - 1
                                                      ? 0
                                                      : AppSpacing.xs,
                                                ),
                                                child: _ProgressBarChartColumn(
                                                  item: items[index],
                                                  color: colors.accentOrange,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static const double _minimumChartHeight = 220;
}

class _ProgressBarChartGrid extends StatelessWidget {
  const _ProgressBarChartGrid();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Positioned.fill(
      top: 28,
      bottom: 34,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var index = 0; index < 4; index++)
            Container(height: 1, color: colors.hairline),
        ],
      ),
    );
  }
}

class _ProgressBarChartColumn extends StatelessWidget {
  const _ProgressBarChartColumn({required this.item, required this.color});

  final ProgressBarChartData item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final percent = item.data.clamp(0, 100);
    final colors = context.colors;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: AppRadius.pill,
            border: Border.all(color: color.withValues(alpha: 0.24)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 2,
            ),
            child: Text(
              '$percent%',
              style: context.textTheme.labelSmall?.copyWith(color: colors.ink),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 44,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: AppRadius.button,
                      border: Border.all(color: color.withValues(alpha: 0.14)),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: percent / 100,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 6),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: AppRadius.button,
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.22),
                            blurRadius: 14,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          height: 28,
          alignment: Alignment.topCenter,
          child: Text(
            item.displayLabel,
            style: context.textTheme.labelSmall?.copyWith(
              color: colors.body,
              height: 1.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
