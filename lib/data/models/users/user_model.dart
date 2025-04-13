class UserModel {
  String id;
  String name;
  String email;
  String documentNumber;
  String phone;
  String mainAddress;
  String password;
  String role;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.documentNumber,
    required this.phone,
    required this.mainAddress,
    required this.password,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      documentNumber: json['documentNumber'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      mainAddress: json['mainAddress'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 'user',
    );
  }
}
