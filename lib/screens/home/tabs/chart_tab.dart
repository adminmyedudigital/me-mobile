import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class ChartTab extends StatelessWidget {
  const ChartTab({super.key});

  @override
  Widget build(BuildContext context) {
    final values = [0.62, 0.8, 0.54, 0.9, 0.72];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        Text('Performance graph', style: context.textTheme.displaySmall),
        const SizedBox(height: AppSpacing.xxl),
        Card(
          child: Padding(
            padding: AppSpacing.card,
            child: SizedBox(
              height: 260,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var index = 0; index < values.length; index++) ...[
                    Expanded(
                      child: _ChartBar(
                        value: values[index],
                        label: 'W${index + 1}',
                      ),
                    ),
                    if (index != values.length - 1)
                      const SizedBox(width: AppSpacing.md),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChartBar extends StatelessWidget {
  const _ChartBar({required this.value, required this.label});

  final double value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: value,
              widthFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.accentBlue,
                  borderRadius: AppRadius.card,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(label, style: context.textTheme.bodySmall),
      ],
    );
  }
}
