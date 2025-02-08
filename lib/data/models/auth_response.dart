import 'package:esvilla_app/domain/entities/auth_response_entity.dart';

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final String role;
  final int expiresIn;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.expiresIn,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        accessToken: json["access_token"] ?? '',
        refreshToken: json["refresh_token"] ?? '',
        role: json["role"] ?? '',
        expiresIn: json["expires_in"] ?? 3600,
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "role": role,
      };

  AuthResponseEntity toEntity() => AuthResponseEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      role: role,
      expiration: expiresIn);
}
