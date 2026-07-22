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
