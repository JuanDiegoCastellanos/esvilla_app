import 'package:esvilla_app/data/models/users/create_user_request.dart';
import 'package:esvilla_app/data/models/users/update_password_request.dart';
import 'package:esvilla_app/data/models/users/user_model.dart';
import 'package:esvilla_app/data/models/users/user_update_request.dart';
import 'package:esvilla_app/domain/entities/user/create_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/update_password_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/update_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';

class UserMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      documentNumber: model.documentNumber,
      phone: model.phone,
      mainAddress: model.mainAddress,
      password: model.password,
      role: model.role,
      
    );
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      documentNumber: entity.documentNumber,
      phone: entity.phone,
      mainAddress: entity.mainAddress,
      role: entity.role,
      password: entity.password,
    );
  }

  static CreateUserRequest toCreateRequest(CreateUserRequestEntity entity) {
    return CreateUserRequest(
        documentNumber: entity.documentNumber,
        name: entity.name,
        email: entity.email,
        phone: entity.phone,
        mainAddress: entity.mainAddress,
        password: entity.password,
        role: entity.role
        // ...
        );
  }

  static UpdateUserRequest toUpdateRequest(UpdateUserRequestEntity entity) {
    return UpdateUserRequest(
      id: entity.id,
      name: entity.name,
      documentNumber: entity.documentNumber,
      email: entity.email,
      phone: entity.phone,
      mainAddress: entity.mainAddress,
      role: entity.role,
      password: entity.password,
    );
  }

  static UpdatePasswordRequest toUpdatePasswordRequest(UpdatePasswordRequestEntity entity) {
    return UpdatePasswordRequest(
      oldPassword: entity.oldPassword,
      newPassword: entity.newPassword,
      confirmNewPassword: entity.confirmNewPassword,
    );
  }
}
