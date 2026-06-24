import 'package:flutter/material.dart';
import 'package:me_mobile/theme/theme.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _DashboardMetric(
        icon: Icons.school,
        label: 'Courses',
        value: '12',
        color: context.colors.accentBlue,
      ),
      _DashboardMetric(
        icon: Icons.assignment_turned_in,
        label: 'Completed',
        value: '8',
        color: context.colors.accentGreen,
      ),
      _DashboardMetric(
        icon: Icons.schedule,
        label: 'Pending',
        value: '4',
        color: context.colors.accentYellow,
      ),
      _DashboardMetric(
        icon: Icons.trending_up,
        label: 'Progress',
        value: '72%',
        color: context.colors.accentOrange,
      ),
      _DashboardMetric(
        icon: Icons.school,
        label: 'Courses',
        value: '12',
        color: context.colors.accentBlue,
      ),
      _DashboardMetric(
        icon: Icons.assignment_turned_in,
        label: 'Completed',
        value: '8',
        color: context.colors.accentGreen,
      ),
      _DashboardMetric(
        icon: Icons.schedule,
        label: 'Pending',
        value: '4',
        color: context.colors.accentYellow,
      ),
      _DashboardMetric(
        icon: Icons.trending_up,
        label: 'Progress',
        value: '72%',
        color: context.colors.accentOrange,
      ),
      _DashboardMetric(
        icon: Icons.school,
        label: 'Courses',
        value: '12',
        color: context.colors.accentBlue,
      ),
      _DashboardMetric(
        icon: Icons.assignment_turned_in,
        label: 'Completed',
        value: '8',
        color: context.colors.accentGreen,
      ),
      _DashboardMetric(
        icon: Icons.schedule,
        label: 'Pending',
        value: '4',
        color: context.colors.accentYellow,
      ),
      _DashboardMetric(
        icon: Icons.trending_up,
        label: 'Progress',
        value: '72%',
        color: context.colors.accentOrange,
      ),
      _DashboardMetric(
        icon: Icons.school,
        label: 'Courses',
        value: '12',
        color: context.colors.accentBlue,
      ),
      _DashboardMetric(
        icon: Icons.assignment_turned_in,
        label: 'Completed',
        value: '8',
        color: context.colors.accentGreen,
      ),
      _DashboardMetric(
        icon: Icons.schedule,
        label: 'Pending',
        value: '4',
        color: context.colors.accentYellow,
      ),
      _DashboardMetric(
        icon: Icons.trending_up,
        label: 'Progress',
        value: '72%',
        color: context.colors.accentOrange,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        Text('ME Digital', style: context.textTheme.displaySmall),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Your learning workspace is ready.',
          style: context.textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.xxl),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 720 ? 2 : 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: AppSpacing.lg,
                mainAxisSpacing: AppSpacing.lg,
                childAspectRatio: columns == 1 ? 3.4 : 2.8,
              ),
              itemBuilder: (context, index) => items[index],
            );
          },
        ),
      ],
    );
  }
}

class _DashboardMetric extends StatelessWidget {
  const _DashboardMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: context.textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(value, style: context.textTheme.headlineMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
