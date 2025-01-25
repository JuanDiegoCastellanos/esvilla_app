import 'package:esvilla_app/data/datasources/auth/auth_remote_data_source.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth/auth_local_data_source.dart';
class AuthLocalRepositoryImpl implements AuthRepository {

  final AuthLocalDataSource authLocalDataSource;

  AuthLocalRepositoryImpl(this.authLocalDataSource);

  @override
  Future<String> login(String email, String password) async {
    return await authLocalDataSource.login(email, password);
  }
}

class AuthRemoteRepositoryImpl extends AuthRepository {

  final AuthRemoteDataSource authRemoteDataSource;

  AuthRemoteRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<String> login(String email, String password) async {
    return await authRemoteDataSource.login(email, password);    
  }

}