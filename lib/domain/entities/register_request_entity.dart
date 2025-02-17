class RegisterRequestEntity {
  final String name;
  final String document;
  final String email;
  final String phone;
  final String password;
  final String direccion;

  const RegisterRequestEntity({
    required this.name,
    required this.document,
    required this.email,
    required this.phone,
    required this.password,
    required this.direccion,
  });

// to Map<String, dynamic> method
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'documentNumber': document,
      'email': email,
      'phone': phone,
      'password': password,
      'mainAddress': direccion
    };
  }
}