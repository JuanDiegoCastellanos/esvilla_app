class UserUpdateDto{
  final String name;
  final String documentNumber;
  final String email;
  final String phone;
  final String mainAddress;

  UserUpdateDto({
    required this.name,
    required this.documentNumber,
    required this.email,
    required this.phone,
    required this.mainAddress,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'documentNumber': documentNumber,
    'email': email,
    'phone': phone,
    'mainAddress': mainAddress,
  };
}