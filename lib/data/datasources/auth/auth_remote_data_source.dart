import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/models/auth/auth_response.dart';
import 'package:esvilla_app/domain/entities/auth/register_request_entity.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'identifier': email, 'password': password},
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(response.data);
      } else {
        AppLogger.e(
            'Failed to login. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to login. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during login: $e');
      // aca lanzar la personalizada sabiendo de que tipo de error es dio
      throw AppException.fromDioExceptionType(e.type);
      //throw Exception('Network error occurred');
    } catch (e) {
      AppLogger.e('Unexpected error during login: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
      //throw Exception('Unexpected error occurred');
    }
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      AppLogger.i('Response Data: ${response.data}');
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Error refreshing token: $e');
    }
  }

  Future<AuthResponse> register(RegisterRequestEntity registerRequestEntity) async {
    try {
    final registerResponse = await dio.post(
        '/users',
        data: {
          'name': registerRequestEntity.name,
          'documentNumber': registerRequestEntity.document,
          'email': registerRequestEntity.email,
          'phone': registerRequestEntity.phone,
          'password': registerRequestEntity.password,
          'mainAddress': registerRequestEntity.direccion
        },
      );

      AppLogger.i('Response Data: ${registerResponse.data}');
      AppLogger.i('Response ${registerResponse.statusMessage}');

      if (registerResponse.statusCode == 200 || registerResponse.statusCode == 201) {
        // login 
        final response = await login(registerRequestEntity.email, registerRequestEntity.password);
        return response;
      } else {
        AppLogger.e(
            'Failed to login. Status: ${registerResponse.statusCode}, Body: ${registerResponse.data}');

        throw Exception(
            'Failed to login. Status: ${registerResponse.statusCode}, Body: ${registerResponse.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during login: $e');
      // aca lanzar la personalizada sabiendo de que tipo de error es dio
      throw AppException.fromDioExceptionType(e.type);
      //throw Exception('Network error occurred');
    } catch (e) {
      AppLogger.e('Unexpected error during login: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
      //throw Exception('Unexpected error occurred');
    }
  }
}
