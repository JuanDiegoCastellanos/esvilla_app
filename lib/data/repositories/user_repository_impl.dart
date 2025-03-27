import 'package:esvilla_app/data/datasources/users/users_remote_data_source.dart';
import 'package:esvilla_app/data/mappers/user/user_mapper.dart';
import 'package:esvilla_app/domain/entities/user/create_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/update_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';

class UserRemoteRepositoryImpl implements UserRepository {
  final UsersRemoteDataSource userRemoteDataSource;

  UserRemoteRepositoryImpl(this.userRemoteDataSource);

  @override
  Future<UserEntity> add(CreateUserRequestEntity createUserRequestEntity) async {
    final createUserRequest = UserMapper.toCreateRequest(createUserRequestEntity);
    final userModelResponse = await userRemoteDataSource.createUser(createUserRequest);
    return UserMapper.toEntity(userModelResponse);
  }

  @override
  Future<UserEntity> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<UserEntity>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> getById(String id) async {
    final userModel = await userRemoteDataSource.getUserById(id);
    return UserMapper.toEntity(userModel);
  }

  @override
  Future<UserEntity> myProfile(String token) {
    // TODO: implement myProfile
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> update(String id, UpdateUserRequestEntity entity) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> updateMyInfo(UpdateUserRequestEntity model, String token) {
    // TODO: implement updateMyInfo
    throw UnimplementedError();
  }
}
