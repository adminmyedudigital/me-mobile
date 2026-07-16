import 'package:me_mobile/models/auth_session_model.dart';

class SignInPayloadModel {
  const SignInPayloadModel({required this.username, required this.password});

  final String username;
  final String password;

  Map<String, dynamic> toJson() {
    return {'username': username.trim(), 'password': password.trim()};
  }
}

class SignInResponseModel {
  const SignInResponseModel({required this.session, required this.raw});

  final AuthSessionModel session;
  final Map<String, dynamic> raw;

  factory SignInResponseModel.fromJson(dynamic value) {
    final json = value is Map<String, dynamic>
        ? value
        : Map<String, dynamic>.from(value as Map);

    return SignInResponseModel(
      session: AuthSessionModel.fromSignInJson(json),
      raw: json,
    );
  }
}
