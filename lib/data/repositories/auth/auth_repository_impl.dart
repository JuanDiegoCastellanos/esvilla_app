import 'package:esvilla_app/data/datasources/auth/auth_remote_data_source.dart';
import 'package:esvilla_app/domain/entities/auth/auth_response_entity.dart';

import '../../../domain/repositories/auth_repository.dart';
import '../../datasources/auth/auth_local_data_source.dart';
class AuthLocalRepositoryImpl implements AuthRepository {

  final AuthLocalDataSource authLocalDataSource;

  AuthLocalRepositoryImpl(this.authLocalDataSource);

  @override
  Future<AuthResponseEntity> login(String email, String password) async {
    return await authLocalDataSource.login(email, password).then((authResponse) => authResponse.toEntity());
  }
  
  @override
  Future<AuthResponseEntity> refreshToken(String refreshToken) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }
}

class AuthRemoteRepositoryImpl extends AuthRepository {

  final AuthRemoteDataSource authRemoteDataSource;

  AuthRemoteRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<AuthResponseEntity> login(String email, String password) async {
    return await authRemoteDataSource.login(email, password).then((authResponse) => authResponse.toEntity());    
  }

  @override
  Future<AuthResponseEntity> refreshToken(String refreshToken) async {
    return await authRemoteDataSource.refreshToken(refreshToken).then((authResponse) => authResponse.toEntity());    
  }

}