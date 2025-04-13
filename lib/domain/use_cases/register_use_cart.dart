import 'package:esvilla_app/domain/entities/auth/auth_response_entity.dart';
import 'package:esvilla_app/domain/entities/auth/register_request_entity.dart';
import 'package:esvilla_app/domain/repositories/register_repository.dart';

class RegisterUseCase {
  final RegisterRepository repository;
  
  RegisterUseCase(this.repository);

  Future<AuthResponseEntity> call(RegisterRequestEntity data) async {
    return await repository.register(data);
  }
}