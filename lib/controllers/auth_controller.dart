import 'package:get/get.dart';

import 'package:me_mobile/utils/utils.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/services/services.dart';
import 'package:me_mobile/controllers/app_controller.dart';
import 'package:me_mobile/controllers/api_controller_mixin.dart';

class AuthController extends GetxController with ApiControllerMixin {
  final RxBool isSigningIn = false.obs;
  final RxBool isUpdatingPassword = false.obs;
  final RxBool isUpdatingUsername = false.obs;
  final Rxn<AuthSessionModel> session = Rxn<AuthSessionModel>();

  AuthStorageService get _storage => Get.find<AuthStorageService>();
  AuthUserModel? get currentUser => session.value?.user;
  AcademicHistoryModel? get academicHistory => session.value?.academicHistory;
  bool get hasAcademicHistory => academicHistory?.hasRequiredData == true;
  String get authToken => session.value?.token ?? '';
  List<SchoolAcademicClassModel> get schoolAcademicClasses =>
      session.value?.schoolAcademicClasses ?? const [];
  bool get isAuthenticated => session.value?.hasValidToken == true;

  Future<bool> signIn(SignInPayloadModel payload) async {
    if (isSigningIn.value) {
      return false;
    }

    isSigningIn.value = true;

    try {
      final response = await api.post<SignInResponseModel>(
        ApiRoutes.studentSignIn,
        body: payload.toJson(),
        fromJson: SignInResponseModel.fromJson,
      );

      if (!response.isSuccess) {
        AppSnackBar.showError(
          title: 'Sign in failed',
          message: response.message,
          fallbackMessage: 'Please check your credentials.',
        );
        return false;
      }

      final authSession = response.data.isEmpty
          ? null
          : response.data.first.session;

      if (authSession == null || !authSession.hasValidToken) {
        await logout();
        AppSnackBar.showError(
          title: 'Sign in failed',
          message: 'Your session token is invalid or expired.',
        );
        return false;
      }

      await _setSession(authSession);
      return true;
    } finally {
      isSigningIn.value = false;
    }
  }

  Future<void> restoreSession() async {
    final storedSession = _storage.readSession();

    if (storedSession == null || !storedSession.hasValidToken) {
      await logout(redirect: false);
      return;
    }

    _setAppSession(storedSession, redirect: false);
  }

  Future<void> updateAcademicHistory(
    AcademicHistoryModel academicHistory,
  ) async {
    final currentSession = session.value;

    if (currentSession == null) {
      return;
    }

    final updatedSession = AuthSessionModel(
      user: currentSession.user,
      token: currentSession.token,
      schoolAcademicClasses: currentSession.schoolAcademicClasses,
      academicHistory: academicHistory,
    );

    await _storage.saveSession(updatedSession);
    session.value = updatedSession;
  }

  Future<bool> updateUsername(UpdateUsernamePayloadModel payload) async {
    if (isUpdatingUsername.value) {
      return false;
    }

    isUpdatingUsername.value = true;

    try {
      final requestBody = payload.toJson();
      final response = await api.put<dynamic>(
        ApiRoutes.updateUsername,
        headers: {'Authorization': 'Bearer $authToken'},
        body: requestBody,
      );

      if (response.status != 200) {
        AppSnackBar.showError(
          title: 'Unable to update username',
          message: response.message,
        );
        return false;
      }

      await logout();
      return true;
    } finally {
      isUpdatingUsername.value = false;
    }
  }

  Future<bool> updatePassword(UpdatePasswordPayloadModel payload) async {
    if (isUpdatingPassword.value) {
      return false;
    }

    isUpdatingPassword.value = true;

    try {
      final response = await api.put<dynamic>(
        ApiRoutes.updatePassword,
        headers: {'Authorization': 'Bearer $authToken'},
        body: payload.toJson(),
      );

      if (response.status != 200) {
        AppSnackBar.showError(
          title: 'Unable to update password',
          message: response.message,
        );
        return false;
      }

      await logout();
      return true;
    } finally {
      isUpdatingPassword.value = false;
    }
  }

  Future<void> validateSession({bool redirect = true}) async {
    final currentSession = session.value ?? _storage.readSession();

    if (currentSession == null || !currentSession.hasValidToken) {
      await logout(redirect: redirect);
      return;
    }

    _setAppSession(currentSession, redirect: false);
  }

  Future<void> logout({bool redirect = true}) async {
    session.value = null;
    await _storage.clearSession();
    Get.find<AppController>().clearAuthState(redirect: redirect);
  }

  Future<void> _setSession(AuthSessionModel authSession) async {
    await _storage.saveSession(authSession);
    _setAppSession(authSession);
  }

  void _setAppSession(AuthSessionModel authSession, {bool redirect = true}) {
    session.value = authSession;
    Get.find<AppController>().setAuthSession(authSession, redirect: redirect);
  }
}
