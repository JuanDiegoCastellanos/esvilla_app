import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/models/auth/auth_response.dart';

class RefreshTokenService {
  final Dio dio;

  RefreshTokenService({required this.dio});

  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken});
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.i('Refresh token response: ${response.data}');
        // Se asume que el response.data contiene {access_token: '...', refresh_token: '...', expiration: ...}
        return AuthResponse.fromJson(response.data);
      }else {
        AppLogger.e(
            'Failed to refresh token. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to refresh token. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } catch (e) {
      AppLogger.e('Error refreshing token: $e');
      throw AppException(message: 'Error refreshing token: $e');
    }
  }

  Future<AuthResponse> refreshTokenv2(String refreshToken) async {
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
