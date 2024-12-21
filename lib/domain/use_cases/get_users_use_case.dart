import 'package:esvilla_app/domain/entities/user_entity.dart';

import '../../data/repositories/user_repository.dart';

class GetUsersUseCase{

  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<UserEntity>> execute() async {
    final users = await repository.fetchUsers();
    return users.map((user) => UserEntity(id:user.id, name: user.name)).toList();
  }

}