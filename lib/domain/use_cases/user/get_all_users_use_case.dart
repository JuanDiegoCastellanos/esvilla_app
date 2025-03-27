import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';

class GetAllUsersUseCase {
  UserRepository repository;

  GetAllUsersUseCase(this.repository);

  Future<List<UserEntity>> call() async  => await repository.getAll();

}