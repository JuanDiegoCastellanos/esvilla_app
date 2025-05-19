import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/auth/refresh_token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthInterceptor extends Interceptor {
  final Ref _ref;
  final Dio dio;

  AuthInterceptor(this._ref, {required this.dio});

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _ref
            .read(authTokenStateNotifierProvider.notifier)
            .getRefreshToken();
        if (refreshToken!.isEmpty) {
          AppLogger.e("No refresh token available");
          return handler.next(err);
        }
        final newAccessToken =
            await _ref.read(authControllerProvider.notifier).refreshToken();

        if (newAccessToken == null) {
          await _ref.read(authControllerProvider.notifier).logout();
          handler.reject(err);
          return;
        }
        final response = await dio.fetch(
          err.requestOptions.copyWith(
            headers: {
              ...err.requestOptions.headers,
              'Authorization': 'Bearer $newAccessToken'
            },
            sendTimeout: err.requestOptions.sendTimeout,
          ),
        );
        return handler.resolve(response);
      } catch (e) {
        await _ref.read(authControllerProvider.notifier).logout();
        return handler.reject(err); 
      }
    }
    _logError(err);
    handler.next(err);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Verificamos si el token está por expirar antes de hacer la solicitud
    final tokenState = _ref.read(authTokenStateNotifierProvider);
    if (tokenState.accessToken != null) {
      final isExpiringSoon = _ref
          .read(authTokenStateNotifierProvider.notifier)
          .isTokenExpiringSoon();

      if (isExpiringSoon) {
        try {
          final refreshToken = await _ref
              .read(authTokenStateNotifierProvider.notifier)
              .getRefreshToken();
          final tokenResponse = await _ref
              .read(refreshTokenServiceProvider)
              .refreshToken(refreshToken!);
          // Guardamos los nuevos tokens
          await _ref.read(authTokenStateNotifierProvider.notifier).saveTokens(
              accessToken: tokenResponse.accessToken,
              refreshToken: tokenResponse.refreshToken,
              expiresIn: tokenResponse.expiresIn,
              role: tokenResponse.role);

          // Usamos el nuevo token para esta solicitud
          options.headers['Authorization'] =
              'Bearer ${tokenResponse.accessToken}';
        } catch (e) {
          // Si hay un error al refrescar, usamos el token actual
          AppLogger.w("Error refreshing token proactively: $e");
          options.headers['Authorization'] = 'Bearer ${tokenState.accessToken}';
        }
      } else {
        
        options.headers['Authorization'] = 'Bearer ${tokenState.accessToken}';
      }
    }
    handler.next(options);
  }

  void _logError(DioException err) {
    AppLogger.e("❌ ERROR[${err.response?.statusCode}] => ${err.message}");
    if (err.response?.data != null) {
      AppLogger.e("📦 Error Data: ${err.response?.data}");
    }
  }
}