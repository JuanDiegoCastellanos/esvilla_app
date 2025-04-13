class UpdateUserRequestEntity {
  final String id;
  final String? name;
  final String? email;
  final String? documentNumber;
  final String? phone;
  final String? mainAddress;
  final String? password;
  final String? role;

  UpdateUserRequestEntity({
    required this.id,
    this.name,
    this.email,
    this.documentNumber,
    this.phone,
    this.mainAddress,
    this.password,
    this.role,
  });
}

