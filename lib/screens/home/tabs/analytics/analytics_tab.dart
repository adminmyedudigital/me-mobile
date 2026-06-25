import 'package:flutter/material.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/progress_card.dart';
import 'package:me_mobile/theme/theme.dart';

class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.band,
      ),
      children: [const ProgressCard()],
    );
    ;
  }
}
