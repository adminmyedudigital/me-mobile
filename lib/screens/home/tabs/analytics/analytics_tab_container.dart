import 'package:flutter/material.dart';
import 'package:me_mobile/screens/home/tabs/analytics/progress_card/progress_card.dart';
import 'package:me_mobile/theme/theme.dart';

class AnalyticsTabContainer extends StatelessWidget {
  const AnalyticsTabContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.band,
      ),
      children: const [ProgressCard()],
    );
  }
}
