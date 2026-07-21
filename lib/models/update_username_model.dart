class UpdateUsernamePayloadModel {
  const UpdateUsernamePayloadModel({
    required this.newUsername,
    required this.password,
  });

  final String newUsername;
  final String password;

  Map<String, dynamic> toJson() {
    return {'new_username': newUsername.trim(), 'password': password.trim()};
  }
}
