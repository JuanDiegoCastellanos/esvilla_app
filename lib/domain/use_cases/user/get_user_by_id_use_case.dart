import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';

class GetUserByIdUseCase {

  UserRepository repository;

  GetUserByIdUseCase(this.repository);

  Future<UserEntity> call(String id) async => await repository.getById(id);

}