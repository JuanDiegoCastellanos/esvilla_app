import 'package:esvilla_app/domain/entities/user/update_password_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';

class UpdatePasswordUseCase {
  final UserRepository _repository;

  UpdatePasswordUseCase(this._repository);

  Future<UserEntity> call(UpdatePasswordRequestEntity model) async {
    return await _repository.updateMyPassword(model);
  }
}
