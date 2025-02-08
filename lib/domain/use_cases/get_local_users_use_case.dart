import 'package:esvilla_app/domain/entities/user_entity.dart';

import '../../data/repositories/user_repository_impl.dart';

class GetUsersUseCase{

  final UserLocalRepositoryImpl repository;

  GetUsersUseCase(this.repository);

  Future<List<UserEntity>> execute() async {
    final users = await repository.getUsers();
    return users.map((user) => UserEntity(id:user.id, name: user.name)).toList();
  }

}