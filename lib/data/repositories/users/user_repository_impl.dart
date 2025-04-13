import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/datasources/users/users_remote_data_source.dart';
import 'package:esvilla_app/data/mappers/users/user_mapper.dart';
import 'package:esvilla_app/domain/entities/user/create_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/update_password_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/update_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';

class UserRemoteRepositoryImpl implements UserRepository {
  final UsersRemoteDataSource userRemoteDataSource;

  UserRemoteRepositoryImpl(this.userRemoteDataSource);

  @override
  Future<UserEntity> add(
      CreateUserRequestEntity createUserRequestEntity) async {
    final createUserRequest =
        UserMapper.toCreateRequest(createUserRequestEntity);
    final userModelResponse =
        await userRemoteDataSource.createUser(createUserRequest);
    return UserMapper.toEntity(userModelResponse);
  }

  @override
  Future<UserEntity> delete(String id) async {
    try {
      if (id.isEmpty) {
        AppLogger.e('The id can not be empty');
        throw AppException(message: 'The id can not be empty');
      }
      final userToDelete = await userRemoteDataSource.deleteUser(id);
      return UserMapper.toEntity(userToDelete);
    } catch (e) {
      AppLogger.e('Unexpected error during delete user by Id: $e');
      throw AppException(message: 'User not found, error ${e.toString()}');
    }
  }

  @override
  Future<List<UserEntity>> getAll() async {
    return await userRemoteDataSource.getAllUsers().then(
        (users) => users.map((user) => UserMapper.toEntity(user)).toList());
  }

  @override
  Future<UserEntity> getById(String id) async {
    try {
      if (id.isEmpty) {
        AppLogger.e('The id can not be empty');
        throw AppException(message: 'The id can not be empty');
      }
      final userModel = await userRemoteDataSource.getUserById(id);
      return UserMapper.toEntity(userModel);
    } catch (e) {
      AppLogger.e('Unexpected error during get user by Id: $e');
      throw AppException(message: 'User not found, error ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> myProfile() async {
    final myProfileUser = await userRemoteDataSource.myProfile();
    return UserMapper.toEntity(myProfileUser);
  }

  @override
  Future<UserEntity> update(String id, UpdateUserRequestEntity entity) async {
    try {
      if (id.isEmpty || id != entity.id) {
        AppLogger.e('The id can not be empty or is not the same');
        throw AppException(message: 'The id can not be empty or is not the same');
      }
      final userToUpdate = UserMapper.toUpdateRequest(entity);
      final userUpdatedModel =
          await userRemoteDataSource.updateUser(userToUpdate);
      return UserMapper.toEntity(userUpdatedModel);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<UserEntity> updateMyInfo(UpdateUserRequestEntity model) async {
    try {
      if (model.id.isEmpty) {
        AppLogger.e('The id can not be empty');
        throw AppException(message: 'The id can not be empty');
      }
      final updateRequestDto = UserMapper.toUpdateRequest(model);
      final userModel =
          await userRemoteDataSource.updateMyInfo(updateRequestDto);
      final userEntity = UserMapper.toEntity(userModel);
      return userEntity;
    } catch (e) {
      AppLogger.e('An error occurred: $e');
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<UserEntity> updateMyPassword(UpdatePasswordRequestEntity model) async {
    try {
      final updateRequestDto = UserMapper.toUpdatePasswordRequest(model);
      final userModel =
          await userRemoteDataSource.updateMyPassword(updateRequestDto);
      final userEntity = UserMapper.toEntity(userModel);
      return userEntity;
    } catch (e) {
      AppLogger.e('An error occurred: $e');
      throw AppException(message: e.toString());
    }
  }  
}
