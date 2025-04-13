class UserEntity {
  final String id;
  final String name;
  final String documentNumber;
  final String email;
  final String phone;
  final String password;
  final String mainAddress;
  final String role;

  UserEntity({
    required this.id,
    required this.name,
    required this.documentNumber,
    required this.email,
    required this.phone,
    required this.password,
    required this.mainAddress,
    required this.role,
  });
}
