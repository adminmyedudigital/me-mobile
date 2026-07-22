import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorageService extends GetxService {
  static const String _themeModeKey = 'theme_mode';

  late final SharedPreferences _preferences;

  Future<ThemeStorageService> init() async {
    _preferences = await SharedPreferences.getInstance();
    return this;
  }

  ThemeMode readThemeMode() {
    return switch (_preferences.getString(_themeModeKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    if (mode == ThemeMode.system) {
      await _preferences.remove(_themeModeKey);
      return;
    }

    await _preferences.setString(_themeModeKey, mode.name);
  }
}
