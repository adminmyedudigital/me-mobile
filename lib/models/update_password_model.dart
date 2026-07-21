class UpdatePasswordPayloadModel {
  const UpdatePasswordPayloadModel({
    required this.existingPassword,
    required this.newPassword,
  });

  final String existingPassword;
  final String newPassword;

  Map<String, dynamic> toJson() {
    return {
      'existing_password': existingPassword.trim(),
      'new_password': newPassword.trim(),
    };
  }
}
