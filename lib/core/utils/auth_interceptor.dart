import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_provider.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/auth/refresh_token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthInterceptor extends Interceptor {
  final Ref _ref;
  final Dio dio;

  AuthInterceptor(this._ref, {required this.dio});

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
      try {
        final refreshToken =
            await _ref.read(authTokenProvider.notifier).getRefreshToken();
        if (refreshToken.isEmpty) {
          AppLogger.e("No refresh token available");
          return handler.next(err);
        }

        final tokenResponse = await _ref
            .read(refreshTokenServiceProvider)
            .refreshToken(refreshToken);

        await _ref.read(authTokenProvider.notifier).saveTokens(
            accessToken: tokenResponse.accessToken,
            refreshToken: tokenResponse.refreshToken,
            expiresIn: tokenResponse.expiresIn,
            role: tokenResponse.role);
        final options = Options(
          method: err.requestOptions.method,
          headers: {
            ...err.requestOptions.headers,
            'Authorization': 'Bearer ${tokenResponse.accessToken}'
          },
        );
        final response = await dio.request(
          err.requestOptions.path,
          options: options,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );
        // Si la solicitud fue exitosa, resolvemos el handler
        return handler.resolve(response);
      } catch (e) {
        AppLogger.e("Error refreshing token ||||||||||: $e");
        // Si hay cualquier error en el proceso de refresh, continuamos con el error original
        return handler.next(err);
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
    // Verificamos si el token está por expirar antes de hacer la solicitud
    final tokenState = _ref.read(authTokenProvider);
    if (tokenState.accessToken != null) {
      final isExpiringSoon =
          _ref.read(authTokenProvider.notifier).isTokenExpiringSoon();

      if (isExpiringSoon) {
        try {
          final refreshToken =
              await _ref.read(authTokenProvider.notifier).getRefreshToken();
          final tokenResponse = await _ref
              .read(refreshTokenServiceProvider)
              .refreshToken(refreshToken);
          // Guardamos los nuevos tokens
          await _ref.read(authTokenProvider.notifier).saveTokens(
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
      }else{
        // Si no está por expirar, usamos el token actual
        options.headers['Authorization'] = 'Bearer ${tokenState.accessToken}';
      }
    }
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
    //AppLogger.e("❌ ERROR[${err.response?.statusCode}] => ${err.message}");
    if (err.response?.data != null) {
      AppLogger.e("📦 Error Data: ${err.response?.data}");
    }
  }
}
