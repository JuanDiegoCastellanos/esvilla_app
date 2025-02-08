import 'package:esvilla_app/domain/entities/auth_response_entity.dart';
import 'package:esvilla_app/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  
  LoginUseCase(this.repository);

  Future<AuthResponseEntity> call( String email, String password) async {
    return await repository.login(email,password);
  }
}