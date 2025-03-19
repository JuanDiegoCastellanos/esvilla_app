import 'package:esvilla_app/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final String documentNumber;
  final String email;
  final String phone;
  final String mainAddress;
  final String role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.documentNumber,
    required this.phone,
    required this.mainAddress,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      documentNumber: json['documentNumber'],
      email: json['email'],
      phone: json['phone'],
      mainAddress: json['mainAddress'],
      role: json['role'],
    );
  }

  
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      documentNumber: documentNumber,
      phone: phone,
      mainAddress: mainAddress,
      role: role,
    );
  }
}
