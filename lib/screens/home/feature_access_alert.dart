import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';
import 'package:me_mobile/widgets/form/me_button.dart';
import 'package:me_mobile/models/feature_access_requirement_model.dart';

Future<void> showFeatureAccessAlert(
  BuildContext context,
  FeatureAccessRequirement requirement,
) async {
  final shouldOpenAction = await showDialog<bool>(
    context: context,
    builder: (context) {
      final colors = context.colors;
      return AlertDialog(
        title: Text(requirement.title),
        content: Text(requirement.message),
        actions: [
          MEButton(
            label: 'Not now',
            fullWidth: true,
            backgroundColor: colors.surfaceElevated,
            foregroundColor: colors.ink,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          SizedBox(height: AppSpacing.md),
          MEButton(
            label: requirement.actionLabel,
            fullWidth: true,
            backgroundColor: colors.primary,
            foregroundColor: colors.primaryOn,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );

  if (shouldOpenAction == true) {
    await Get.toNamed<void>(requirement.actionRoute);
  }
}
