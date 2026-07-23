import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class ExamSubjectsLoadingOverlay extends StatelessWidget {
  const ExamSubjectsLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      children: [
        ModalBarrier(
          dismissible: false,
          color: colors.canvas.withValues(alpha: 0.72),
        ),
        Center(
          child: Card(
            color: colors.surfaceElevated,
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Loading subjects and topics...',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
