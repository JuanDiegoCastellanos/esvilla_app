import 'package:esvilla_app/domain/entities/user/user_entity.dart';

class UserPresentationModel {
  final String? id;
  final String? name;
  final String? email;
  final String? documentNumber;
  final String? phone;
  final String? mainAddress;
  final String? role;
  final bool isLoading;
  final String? error;

  UserPresentationModel(this.id, this.name, this.email, this.documentNumber, this.phone,
      this.mainAddress, this.role, this.isLoading, this.error);

  static UserPresentationModel fromEntity(UserEntity entity) {
    return UserPresentationModel(
      entity.id,
      entity.name,
      entity.email,
      entity.documentNumber,
      entity.phone,
      entity.mainAddress,
      entity.role,
      false,
      null,
    );
  }

  UserPresentationModel.empty() : this(null, null, null, null, null, null, null, false, null);

  UserPresentationModel copyWith({
    String? id,
    String? name,
    String? email,
    String? documentNumber,
    String? phone,
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
      mainAddress ?? this.mainAddress,
      role ?? this.role,
      isLoading ?? this.isLoading,
      error ?? this.error,
    );
  }
}
