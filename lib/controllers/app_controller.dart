import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/routes/app_routes.dart';
import 'package:me_mobile/services/services.dart';

class AppController extends GetxController {
  static const UserProfile _emptyProfile = UserProfile(
    firstName: '',
    lastName: '',
    email: '',
    phoneNumber: '',
    username: '',
    password: '',
  );

  final RxBool isAuthenticated = false.obs;
  final Rx<ThemeMode> themeMode = Get.find<ThemeStorageService>()
      .readThemeMode()
      .obs;
  final Rx<UserProfile> profile = _emptyProfile.obs;

  bool isDarkModeFor(BuildContext context) {
    return switch (themeMode.value) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    await Get.find<ThemeStorageService>().saveThemeMode(mode);
  }

  Future<void> toggleTheme(bool useDarkMode) async {
    await setThemeMode(useDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  void setAuthSession(AuthSessionModel session, {bool redirect = true}) {
    profile.value = profile.value.copyWith(
      firstName: session.user.firstName,
      lastName: session.user.lastName,
      email: session.user.email,
      phoneNumber: session.user.phoneNumber,
      username: session.user.username,
      password: '',
    );
    isAuthenticated.value = true;

    if (redirect) {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  void markAuthenticated() {
    isAuthenticated.value = true;
    Get.offAllNamed(AppRoutes.home);
  }

  void updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    String? username,
    String? password,
  }) {
    profile.value = profile.value.copyWith(
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: email.trim(),
      phoneNumber: phoneNumber.trim(),
      username: _cleanOrNull(username),
      password: _cleanOrNull(password),
    );
  }

  void changePassword(String password) {
    profile.value = profile.value.copyWith(password: password.trim());
  }

  void changeUsername(String username) {
    profile.value = profile.value.copyWith(username: username.trim());
  }

  void clearAuthState({bool redirect = true}) {
    isAuthenticated.value = false;
    profile.value = _emptyProfile;

    if (redirect) {
      Get.offAllNamed(AppRoutes.signIn);
    }
  }

  String? _cleanOrNull(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
