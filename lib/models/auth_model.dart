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
