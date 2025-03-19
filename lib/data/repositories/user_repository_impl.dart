import 'package:esvilla_app/data/datasources/user/user_remote_data_source.dart';
import 'package:esvilla_app/domain/entities/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';

class UserRemoteRepositoryImpl implements UserRepository{

  final UserRemoteDataSource  userRemoteDataSource;

  UserRemoteRepositoryImpl(this.userRemoteDataSource);

  @override
  Future<UserEntity> myProfile(String token) {
    return userRemoteDataSource.myProfile(token).then((userModel) => userModel.toEntity());
  }

}