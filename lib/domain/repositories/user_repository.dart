import 'package:esvilla_app/domain/entities/user/create_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/update_password_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/update_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/generic_repository.dart';

abstract class UserRepository implements GenericRepository<UserEntity, CreateUserRequestEntity, UpdateUserRequestEntity> {

  Future<UserEntity> myProfile();

  Future<UserEntity> updateMyInfo(UpdateUserRequestEntity model);

  Future<UserEntity> updateMyPassword(UpdatePasswordRequestEntity model);
}