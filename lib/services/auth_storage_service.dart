import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:me_mobile/models/models.dart';

class AuthStorageService extends GetxService {
  static const String _sessionKey = 'auth_session';

  late final SharedPreferences _preferences;

  Future<AuthStorageService> init() async {
    _preferences = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> saveSession(AuthSessionModel session) async {
    await _preferences.setString(_sessionKey, jsonEncode(session.toJson()));
  }

  AuthSessionModel? readSession() {
    final value = _preferences.getString(_sessionKey);

    if (value == null || value.trim().isEmpty) {
      return null;
    }

    try {
      return AuthSessionModel.fromJson(
        Map<String, dynamic>.from(jsonDecode(value) as Map),
      );
    } on Object {
      return null;
    }
  }

  Future<void> clearSession() async {
    await _preferences.remove(_sessionKey);
  }
}
