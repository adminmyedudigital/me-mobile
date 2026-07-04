import 'dart:convert';

class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.username,
    required this.isActive,
    required this.isAccountVerified,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String username;
  final bool isActive;
  final bool isAccountVerified;

  String get fullName => '$firstName $lastName'.trim();

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      firstName: (json['first_name'] ?? '').toString(),
      lastName: (json['last_name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phoneNumber: (json['phone_number'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      isActive: json['is_active'] == true,
      isAccountVerified: json['is_account_verified'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'username': username,
      'is_active': isActive,
      'is_account_verified': isAccountVerified,
    };
  }
}

class AuthSessionModel {
  const AuthSessionModel({required this.user, required this.token});

  final AuthUserModel user;
  final String token;

  bool get hasValidToken => token.trim().isNotEmpty && !isTokenExpired;

  bool get isTokenExpired {
    final expiry = expiresAt;
    return expiry == null || !expiry.isAfter(DateTime.now());
  }

  DateTime? get expiresAt {
    final payload = _jwtPayload;
    final exp = payload?['exp'];

    if (exp is int) {
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    }

    if (exp is String) {
      final seconds = int.tryParse(exp);
      return seconds == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    }

    return null;
  }

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      user: AuthUserModel.fromJson(Map<String, dynamic>.from(json['user'])),
      token: (json['token'] ?? '').toString(),
    );
  }

  factory AuthSessionModel.fromSignInJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      user: AuthUserModel.fromJson(json),
      token: (json['token'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'token': token};
  }

  Map<String, dynamic>? get _jwtPayload {
    final parts = token.split('.');

    if (parts.length != 3) {
      return null;
    }

    try {
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      return Map<String, dynamic>.from(jsonDecode(payload) as Map);
    } on FormatException {
      return null;
    }
  }
}
