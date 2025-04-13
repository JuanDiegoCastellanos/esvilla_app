import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';

class GetMyProfileUseCase {
  final UserRepository _userRepository;
  GetMyProfileUseCase(this._userRepository);

  Future<UserEntity> call() async => await _userRepository.myProfile();
  
}