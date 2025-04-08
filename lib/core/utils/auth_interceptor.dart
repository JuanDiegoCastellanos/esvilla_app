import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/config/dio_config.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_provider.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_provider.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/auth/refresh_token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthInterceptor extends Interceptor {
  final Ref _ref;

  AuthInterceptor(this._ref);

  @override

  /// Intercepta las respuestas con un estado de 401 (Unauthorized) y
  /// intenta refrescar el token de acceso. Si el token se puede refrescar,
  /// se reintenta la solicitud original con el nuevo token. Si no se puede
  /// refrescar, se registra un error y se llama a
  /// [ErrorInterceptorHandler.next] con el error original.
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Lee el refresh token actual del estado
      final refreshToken = _ref.read(authTokenProvider).refreshToken;
      //final newToken = await _ref.read(authControllerProvider.notifier).refreshToken();
      if (refreshToken != null) {
        // Usa el servicio para refrescar el token
        final data = await _ref
            .read(refreshTokenServiceProvider)
            .refreshToken(refreshToken);
        final newToken = data.accessToken;
        // Actualizar el token en storage/estado mediante tu lógica (por ejemplo, usando AuthController)
        await _ref.read(authControllerProvider.notifier).updateTokenFromRefresh(
            newAccessToken: data.accessToken,
            newRefreshToken: data.refreshToken,
            newExpiration: data.expiresIn,
          );
        // Reintentar la solicitud original
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final dio = _ref.read(dioClientProvider).dio;
        try {
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
            }
    }
    _logError(err);
    handler.next(err);
  }

  @override

  /// Agrega el token de autenticación a la solicitud, si se encuentra disponible.
  ///
  /// Antes de realizar la solicitud, se verifica si se encuentra disponible el
  /// token de autenticación en el state de [AuthTokenStateNotifier]. Si se
  /// encuentra disponible, se agrega el header 'Authorization' con el valor
  /// 'Bearer <token>' a la solicitud. Luego, se llama a [RequestInterceptorHandler.next]
  /// para continuar con la solicitud.
  ///
  /// Si no se encuentra disponible el token de autenticación, la solicitud se
  /// realizará sin el header 'Authorization'.
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Lógica de autenticación
    final token = _ref.read(authTokenProvider).accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  /// Registra un error en el logger, con el código de estado HTTP y el
  /// mensaje de error. Si hay datos de error, también se registran.
  void _logError(DioException err) {
    AppLogger.e("❌ ERROR[${err.response?.statusCode}] => ${err.message}");
    if (err.response?.data != null) {
      AppLogger.e("📦 Error Data: ${err.response?.data}");
    }
  }
}
