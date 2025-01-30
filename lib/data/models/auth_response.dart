import 'dart:convert';

import 'package:esvilla_app/domain/entities/auth_response_entity.dart';

AuthResponse authResponseFromJson(String str) => AuthResponse.fromJson(json.decode(str));

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
    final String accessToken;
    final String role;

    AuthResponse({
        required this.accessToken,
        required this.role,
    });

    factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        accessToken: json["access_token"] ?? '',
        role: json["role"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "role": role,
    };

  AuthResponseEntity toEntity() => AuthResponseEntity(accessToken: accessToken, role: role);
}