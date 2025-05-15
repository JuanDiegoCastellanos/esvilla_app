import 'package:esvilla_app/domain/entities/user/create_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/update_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';

class UserPresentationModel {
  final String? id;
  final String? name;
  final String? email;
  final String? documentNumber;
  final String? phone;
  final String? password;
  final String? mainAddress;
  final String? role;
  final bool isLoading;
  final String? error;

  UserPresentationModel(this.id, this.name, this.email, this.documentNumber, this.phone, this.password,
      this.mainAddress, this.role, this.isLoading, this.error);

  static UserPresentationModel fromEntity(UserEntity entity) {
    return UserPresentationModel(
      entity.id,
      entity.name,
      entity.email,
      entity.documentNumber,
      entity.phone,
      entity.password,
      entity.mainAddress,
      entity.role,
      false,
      null,
    );
  }

    static UserEntity toEntity(UserPresentationModel entity) {
    return UserEntity(
      id: entity.id ?? '',
      name: entity.name ?? '',
      email: entity.email ?? '',
      documentNumber:  entity.documentNumber ?? '',
      phone:  entity.phone ?? '',
      password:  entity.password ?? '',
      mainAddress:  entity.mainAddress ?? '',
      role:  entity.role ?? '',
    );
  }


  static UserPresentationModel fromUpdateUserRequestEntity(UpdateUserRequestEntity entity) {
    return UserPresentationModel(
      entity.id,
      entity.name,
      entity.email,
      entity.documentNumber,
      entity.phone,
      entity.password,
      entity.mainAddress,
      entity.role,
      false,
      null,
    );
  }
    static UpdateUserRequestEntity toUpdateUserRequestEntity(UserPresentationModel entity) {
    return UpdateUserRequestEntity(
      id:entity.id!,
      name: entity.name,
      email:  entity.email,
      documentNumber:  entity.documentNumber,
      phone: entity.phone,
      password: entity.password,
      mainAddress: entity.mainAddress,
      role: entity.role,
    );
  }

  static CreateUserRequestEntity toCreateUserRequestEntity(UserPresentationModel entity) {
    return CreateUserRequestEntity(
      name: entity.name!,
      email:  entity.email!,
      documentNumber:  entity.documentNumber!,
      phone: entity.phone!,
      password: entity.password!,
      mainAddress: entity.mainAddress!,
      role: entity.role!,
    );
  }


  UserPresentationModel.empty() : this(null, null, null, null, null,null, null, null, false, null);

  UserPresentationModel copyWith({
    String? id,
    String? name,
    String? email,
    String? documentNumber,
    String? phone,
    String? password,
    String? mainAddress,
    String? role,
    bool? isLoading,
    String? error,
  }) {
    return UserPresentationModel(
      id ?? this.id,
      name ?? this.name,
      email ?? this.email,
      documentNumber ?? this.documentNumber,
      phone ?? this.phone,
      password ?? this.password,
      mainAddress ?? this.mainAddress,
      role ?? this.role,
      isLoading ?? this.isLoading,
      error ?? this.error,
    );
  }
  
  factory UserPresentationModel.partly({
    String? id,
    String? name,
    String? email,
    String? documentNumber,
    String? phone,
    String? password,
    String? mainAddress,
    String? role,
    bool isLoading = false,
    String? error,
  }) {
    return UserPresentationModel(
      id,
      name,
      email,
      documentNumber,
      phone,
      password,
      mainAddress,
      role,
      isLoading,
      error,
    );
  }
}
