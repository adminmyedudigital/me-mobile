import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:me_mobile/theme/theme.dart';

abstract final class AppSnackBar {
  static void showError({
    required String title,
    required String message,
    String fallbackMessage = 'Something went wrong.',
  }) {
    final context = Get.context;
    final theme = context == null ? Get.theme : Theme.of(context);
    final colors = theme.extension<AppColors>() ?? AppColors.lightBrand();
    final isDarkTheme = theme.brightness == Brightness.dark;

    Get.snackbar(
      title,
      message.trim().isEmpty ? fallbackMessage : message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isDarkTheme ? colors.accentRed : colors.accentRedGlow,
      colorText: isDarkTheme ? colors.primary : colors.accentRed,
    );
  }
}
