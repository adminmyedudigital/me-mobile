import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/widgets.dart';

class ExamsTabNoData extends StatelessWidget {
  const ExamsTabNoData({
    super.key,
    this.message = 'No exam results are available yet.',
    this.icon = Icons.assignment_outlined,
    this.onRetry,
  });

  final String message;
  final IconData icon;
  final Future<bool> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 40, color: context.colors.ash),
                    const SizedBox(height: AppSpacing.md),
                    Text(message, textAlign: TextAlign.center),
                    if (onRetry != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      MEButton(
                        label: 'Retry',
                        onPressed: onRetry,
                        backgroundColor: context.colors.primary,
                        foregroundColor: context.colors.primaryOn,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
