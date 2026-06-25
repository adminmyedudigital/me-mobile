import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class ProgressMetricData {
  const ProgressMetricData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
}

class ProgressMetricGrid extends StatelessWidget {
  const ProgressMetricGrid({super.key, required this.metrics});

  final List<ProgressMetricData> metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: AppSpacing.md),
                child: ProgressMetric(data: metrics[0]),
              ),
            ),
            Expanded(child: ProgressMetric(data: metrics[1])),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: AppSpacing.md),
                child: ProgressMetric(data: metrics[2]),
              ),
            ),
            Expanded(child: ProgressMetric(data: metrics[3])),
          ],
        ),
      ],
    );
  }
}

class ProgressMetric extends StatelessWidget {
  const ProgressMetric({super.key, required this.data});

  final ProgressMetricData data;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceDeep.withAlpha(150),
        borderRadius: AppRadius.card,
        border: Border.all(color: data.color.withAlpha(46)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            data.color.withAlpha(18),
            context.colors.surfaceDeep.withAlpha(180),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            _ProgressMetricIcon(icon: data.icon, color: data.color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: context.textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    data.value,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressMetricIcon extends StatelessWidget {
  const _ProgressMetricIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withAlpha(24),
        borderRadius: AppRadius.card,
        border: Border.all(color: color.withAlpha(48)),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
