import 'package:esvilla_app/domain/entities/auth/auth_response_entity.dart';
import 'package:esvilla_app/domain/entities/auth/register_request_entity.dart';

abstract class RegisterRepository {
  Future<AuthResponseEntity> register(RegisterRequestEntity requestData);
}