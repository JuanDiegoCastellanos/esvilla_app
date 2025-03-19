import 'package:esvilla_app/domain/entities/user_entity.dart';

abstract class UserRepository {
  
  Future<UserEntity> myProfile(String token);

}