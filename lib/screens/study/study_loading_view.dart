import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';

class StudyLoadingView extends StatelessWidget {
  const StudyLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: context.colors.primary),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Fetching subjects and academic status details',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
