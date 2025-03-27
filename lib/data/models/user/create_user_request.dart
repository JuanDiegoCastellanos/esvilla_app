class CreateUserRequest {
  final String name;
  final String documentNumber;
  final String email;
  final String phone;
  final String password;
  final String mainAddress;
  final String role;

  CreateUserRequest({
    required this.name,
    required this.documentNumber,
    required this.email,
    required this.phone,
    required this.password,
    required this.mainAddress,
    required this.role,
  });

  factory CreateUserRequest.fromMap(Map<String, dynamic> json) => CreateUserRequest(
        name: json["name"],
        documentNumber: json["documentNumber"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
        mainAddress: json["mainAddress"],
        role: json["role"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "documentNumber": documentNumber,
        "email": email,
        "phone": phone,
        "password": password,
        "mainAddress": mainAddress,
        "role": role,
      };
}
