import 'package:esvilla_app/domain/entities/user/update_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';

class UpdateMyProfileUseCase{
  final UserRepository _repository;

  const UpdateMyProfileUseCase(this._repository);

  Future<UserEntity> call(UpdateUserRequestEntity model) async => await _repository.updateMyInfo(model);
  
}