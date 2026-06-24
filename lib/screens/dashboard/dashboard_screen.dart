import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../theme/theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text('ME Digital', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your learning workspace is ready.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.xxl),
            _DashboardGrid(colors: colors),
          ],
        ),
      ),
    );
  }
}

class _DashboardGrid extends StatelessWidget {
  const _DashboardGrid({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final items = [
      _DashboardItem(
        icon: Icons.school,
        label: 'Courses',
        value: '12',
        color: colors.accentBlue,
      ),
      _DashboardItem(
        icon: Icons.assignment_turned_in,
        label: 'Completed',
        value: '8',
        color: colors.accentGreen,
      ),
      _DashboardItem(
        icon: Icons.schedule,
        label: 'Pending',
        value: '4',
        color: colors.accentYellow,
      ),
      _DashboardItem(
        icon: Icons.trending_up,
        label: 'Progress',
        value: '72%',
        color: colors.accentOrange,
      ),
    ];

    return LayoutBuilder(
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
    );
  }
}

class _DashboardItem extends StatelessWidget {
  const _DashboardItem({
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
                  Text(label, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium,
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
