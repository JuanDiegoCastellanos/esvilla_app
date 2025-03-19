import 'package:esvilla_app/domain/entities/user_entity.dart';

import '../../data/repositories/user_repository_impl.dart';

class GetUsersUseCase{

  final UserRemoteRepositoryImpl repository;

  GetUsersUseCase(this.repository);

  Future<List<UserEntity>> execute() async {
    throw UnimplementedError('GetUsersUseCase.execute() has not been implemented yet.');
  }

}