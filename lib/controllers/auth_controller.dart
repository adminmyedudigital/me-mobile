import 'package:get/get.dart';

import 'package:me_mobile/controllers/api_controller_mixin.dart';
import 'package:me_mobile/controllers/app_controller.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/services/services.dart';
import 'package:me_mobile/utils/utils.dart';

class AuthController extends GetxController with ApiControllerMixin {
  final RxBool isSigningIn = false.obs;
  final Rxn<AuthSessionModel> session = Rxn<AuthSessionModel>();

  AuthStorageService get _storage => Get.find<AuthStorageService>();

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

  Future<void> validateSession({bool redirect = true}) async {
    final currentSession = session.value ?? _storage.readSession();

    if (currentSession == null || !currentSession.hasValidToken) {
      await logout(redirect: redirect);
      return;
    }

    _setAppSession(currentSession);
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
