import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/routes/app_routes.dart';

class UserProfile {
  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.username,
    required this.password,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String username;
  final String password;

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? username,
    String? password,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}

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
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  final Rx<UserProfile> profile = _emptyProfile.obs;

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
  }

  void toggleTheme(bool useDarkMode) {
    setThemeMode(useDarkMode ? ThemeMode.dark : ThemeMode.light);
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
