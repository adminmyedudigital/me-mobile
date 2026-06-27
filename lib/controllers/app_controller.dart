import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/routes/app_routes.dart';

class AppController extends GetxController {
  final RxBool isAuthenticated = false.obs;
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
  }

  void toggleTheme(bool useDarkMode) {
    setThemeMode(useDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  void signIn() {
    isAuthenticated.value = true;
    Get.offAllNamed(AppRoutes.home);
  }

  void signOut() {
    isAuthenticated.value = false;
    Get.offAllNamed(AppRoutes.signIn);
  }
}
