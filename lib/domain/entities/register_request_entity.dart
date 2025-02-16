class RegisterRequestEntity {
  final String name;
  final String document;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  const RegisterRequestEntity({
    required this.name,
    required this.document,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });
}