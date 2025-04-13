import 'package:esvilla_app/data/datasources/auth/auth_remote_data_source.dart';
import 'package:esvilla_app/domain/entities/auth/auth_response_entity.dart';
import 'package:esvilla_app/domain/entities/auth/register_request_entity.dart';
import 'package:esvilla_app/domain/repositories/register_repository.dart';

class RegisterRepositoryImpl extends RegisterRepository{

   final AuthRemoteDataSource authRemoteDataSource;

  RegisterRepositoryImpl(this.authRemoteDataSource);
   

  @override
  Future<AuthResponseEntity> register(RegisterRequestEntity requestData) {
      return authRemoteDataSource.register(requestData).then(
        (authResponse) => authResponse.toEntity()
      );
  }

}