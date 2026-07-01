import 'package:flutter/material.dart';

import 'package:get/get.dart';

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

class StudySettings {
  const StudySettings({
    required this.schoolName,
    required this.educationBoard,
    required this.className,
    this.academicStartMonth,
    this.academicStartYear,
    this.academicEndMonth,
    this.academicEndYear,
  });

  final String schoolName;
  final String educationBoard;
  final String className;
  final int? academicStartMonth;
  final int? academicStartYear;
  final int? academicEndMonth;
  final int? academicEndYear;

  StudySettings copyWith({
    String? schoolName,
    String? educationBoard,
    String? className,
    int? academicStartMonth,
    int? academicStartYear,
    int? academicEndMonth,
    int? academicEndYear,
  }) {
    return StudySettings(
      schoolName: schoolName ?? this.schoolName,
      educationBoard: educationBoard ?? this.educationBoard,
      className: className ?? this.className,
      academicStartMonth: academicStartMonth ?? this.academicStartMonth,
      academicStartYear: academicStartYear ?? this.academicStartYear,
      academicEndMonth: academicEndMonth ?? this.academicEndMonth,
      academicEndYear: academicEndYear ?? this.academicEndYear,
    );
  }
}

class AppController extends GetxController {
  final RxBool isAuthenticated = false.obs;
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  final Rx<UserProfile> profile = const UserProfile(
    firstName: '',
    lastName: '',
    email: '',
    phoneNumber: '',
    username: '',
    password: '',
  ).obs;
  final Rx<StudySettings> studySettings = const StudySettings(
    schoolName: '',
    educationBoard: '',
    className: '',
  ).obs;

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
  }

  void toggleTheme(bool useDarkMode) {
    setThemeMode(useDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  void signIn({String? username, String? password}) {
    if ((username ?? '').trim().isNotEmpty ||
        (password ?? '').trim().isNotEmpty) {
      profile.value = profile.value.copyWith(
        username: _cleanOrNull(username),
        password: _cleanOrNull(password),
      );
    }

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

  void updateStudySettings({
    required String schoolName,
    required String educationBoard,
    required String className,
    required int academicStartMonth,
    required int academicStartYear,
    required int academicEndMonth,
    required int academicEndYear,
  }) {
    studySettings.value = studySettings.value.copyWith(
      schoolName: schoolName.trim(),
      educationBoard: educationBoard.trim(),
      className: className.trim(),
      academicStartMonth: academicStartMonth,
      academicStartYear: academicStartYear,
      academicEndMonth: academicEndMonth,
      academicEndYear: academicEndYear,
    );
  }

  void signOut() {
    isAuthenticated.value = false;
    Get.offAllNamed(AppRoutes.signIn);
  }

  String? _cleanOrNull(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
