import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:me_mobile/controllers/controllers.dart';
import 'package:me_mobile/theme/theme.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      final isDarkMode = appController.isDarkMode;

      return IconButton(
        tooltip: isDarkMode ? 'Switch to light theme' : 'Switch to dark theme',
        onPressed: () => appController.toggleTheme(!isDarkMode),
        style: IconButton.styleFrom(
          backgroundColor: context.colors.surfaceElevated.withValues(
            alpha: 0.78,
          ),
          foregroundColor: context.colors.ink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: context.colors.hairlineStrong),
          ),
        ),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: Tween<double>(begin: 0.75, end: 1).animate(animation),
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: Icon(
            isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            key: ValueKey(isDarkMode),
          ),
        ),
      );
    });
  }
}
