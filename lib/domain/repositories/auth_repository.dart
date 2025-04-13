import 'package:esvilla_app/domain/entities/auth/auth_response_entity.dart';

abstract class AuthRepository {
  Future<AuthResponseEntity> login(String email, String password);
  Future<AuthResponseEntity> refreshToken(String refreshToken);
}