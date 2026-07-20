import 'package:flutter/material.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/screens/home/tabs/settings/app_details/app_detail_row.dart';

class SettingsAppDetailsCard extends StatelessWidget {
  const SettingsAppDetailsCard({
    required this.contactNumber,
    required this.appVersionName,
    super.key,
  });

  final String contactNumber;
  final String appVersionName;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colors.surfaceElevated,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App details',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Support contact and app version information.',
              style: context.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppDetailRow(
              icon: Icons.phone_outlined,
              label: 'Contact number',
              value: contactNumber,
            ),
            Divider(height: AppSpacing.xs, color: context.colors.hairline),
            AppDetailRow(
              icon: Icons.info_outline_rounded,
              label: 'App version name',
              value: appVersionName,
            ),
          ],
        ),
      ),
    );
  }
}
