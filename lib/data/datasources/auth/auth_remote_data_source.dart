import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/data/models/auth_response.dart';

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
        AppLogger.e('Failed to login. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to login. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during login: $e');
      throw Exception('Network or server error: ${e.message}');
    } catch (e) {
      AppLogger.e('Unexpected error during login: $e');
      throw Exception('Unexpected error occurred');
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
}
