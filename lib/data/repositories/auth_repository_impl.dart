import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth/auth_local_data_source.dart';
class AuthRepositoryImpl implements AuthRepository {
  final AuthMockDataSource mockDataSource;

  AuthRepositoryImpl(this.mockDataSource);

  @override
  Future<String> login(String email, String password) async {
    //return await remoteDataSource.login(email, password);
    return await mockDataSource.login(email, password);
  }
}
