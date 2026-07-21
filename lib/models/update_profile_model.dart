class UpdateProfilePayloadModel {
  const UpdateProfilePayloadModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName.trim(),
      'last_name': lastName.trim(),
      'email': email.trim(),
      'phone_number': phoneNumber.trim(),
    };
  }
}
