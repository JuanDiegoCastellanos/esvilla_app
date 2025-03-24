import 'package:esvilla_app/domain/entities/create_user_request_entity.dart';

class CreateUserRequest extends CreateUserRequestEntity {
  
  CreateUserRequest({
    required super.name,
    required super.documentNumber,
    required super.email,
    required super.phone,
    required super.password,
    required super.mainAddress,
    required super.role,
  }):super();

  factory CreateUserRequest.fromMap(Map<String, dynamic> json) =>
      CreateUserRequest(
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
