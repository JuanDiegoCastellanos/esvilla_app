import 'package:dio/dio.dart';

import 'package:esvilla_app/core/utils/auth_interceptor.dart';
import 'package:esvilla_app/data/models/auth/auth_response.dart';
import 'package:esvilla_app/data/datasources/auth/refresh_token_service.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_state.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/auth/refresh_token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRef extends Mock implements Ref {}

class MockAuthTokenStateNotifier extends Mock
    implements AuthTokenStateNotifier {}

class MockAuthController extends Mock implements AuthController {}

class MockDio extends Mock implements Dio {}

// Mock personalizado para RefreshTokenService
class MockRefreshTokenService extends RefreshTokenService {
  MockRefreshTokenService() : super(dio: MockDio());

  // Variable para almacenar el comportamiento del mock
  Future<AuthResponse> Function(String)? _refreshTokenBehavior;

  void mockRefreshToken(Future<AuthResponse> Function(String) behavior) {
    _refreshTokenBehavior = behavior;
  }

  @override
  Future<AuthResponse> refreshToken(String refreshToken) async {
    if (_refreshTokenBehavior != null) {
      return await _refreshTokenBehavior!(refreshToken);
    }
    throw UnimplementedError('refreshToken not mocked');
  }
}

class MockRequestOptions extends Mock implements RequestOptions {}

class MockResponse extends Mock implements Response {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

void main() {
  late MockRef ref;
  late MockDio dio;
  late AuthInterceptor interceptor;
  late MockAuthTokenStateNotifier tokenNotifier;
  late MockAuthController authController;
  late MockRefreshTokenService refreshService;

  setUpAll(() {
    // Registrar fallback values para mocktail
    registerFallbackValue(RequestOptions(path: '/'));
    registerFallbackValue(DioException(
      requestOptions: RequestOptions(path: '/'),
      type: DioExceptionType.connectionTimeout,
    ));
    registerFallbackValue(Response(
      requestOptions: RequestOptions(path: '/'),
      statusCode: 200,
    ));
  });

  setUp(() {
    ref = MockRef();
    dio = MockDio();
    tokenNotifier = MockAuthTokenStateNotifier();
    authController = MockAuthController();
    refreshService = MockRefreshTokenService();

    // Configurar los mocks para el Ref
    when(() => ref.read(authTokenStateNotifierProvider.notifier))
        .thenReturn(tokenNotifier);
    when(() => ref.read(authControllerProvider.notifier))
        .thenReturn(authController);
    when(() => ref.read(refreshTokenServiceProvider))
        .thenReturn(refreshService);
    when(() => ref.read(authTokenStateNotifierProvider))
        .thenReturn(const AuthTokenState(accessToken: 'test-token'));

    interceptor = AuthInterceptor(ref, dio: dio);
  });

  group('onRequest', () {
    test('agrega token de autorización a las cabeceras si existe', () async {
      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();

      when(() => tokenNotifier.isTokenExpiringSoon()).thenReturn(false);

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer test-token');
      verify(() => handler.next(options)).called(1);
    });

    test('refresca el token si está por expirar', () async {
      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();

      when(() => tokenNotifier.isTokenExpiringSoon()).thenReturn(true);
      when(() => tokenNotifier.getRefreshToken())
          .thenAnswer((_) async => 'refresh-token');

      // Configurar el comportamiento del mock
      refreshService.mockRefreshToken((_) async => AuthResponse(
          accessToken: 'new-token',
          refreshToken: 'new-refresh',
          role: 'user',
          expiresIn: 3600));

      when(() => tokenNotifier.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            expiresIn: any(named: 'expiresIn'),
            role: any(named: 'role'),
          )).thenAnswer((_) async => {});

      await interceptor.onRequest(options, handler);

      verify(() => tokenNotifier.saveTokens(
          accessToken: 'new-token',
          refreshToken: 'new-refresh',
          expiresIn: 3600,
          role: 'user')).called(1);

      expect(options.headers['Authorization'], 'Bearer new-token');
      verify(() => handler.next(options)).called(1);
    });

    test('maneja error cuando el refresh token es null', () async {
      final options = RequestOptions(path: '/test');
      final handler = MockRequestInterceptorHandler();

      when(() => tokenNotifier.isTokenExpiringSoon()).thenReturn(true);
      when(() => tokenNotifier.getRefreshToken()).thenAnswer((_) async => null);

      await interceptor.onRequest(options, handler);

      // Debería usar el token actual si no puede refrescar
      expect(options.headers['Authorization'], 'Bearer test-token');
      verify(() => handler.next(options)).called(1);
    });
  });

  group('onError', () {
    test('intenta refrescar el token cuando recibe error 401', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );
      final handler = MockErrorInterceptorHandler();

      when(() => tokenNotifier.getRefreshToken())
          .thenAnswer((_) async => 'refresh-token');
      when(() => authController.refreshToken())
          .thenAnswer((_) async => 'new-token');
      when(() => dio.fetch(any())).thenAnswer((_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: '/test'),
          ));
      when(() => handler.resolve(any())).thenAnswer((_) async => {});

      await interceptor.onError(dioError, handler);

      verify(() => authController.refreshToken()).called(1);
      verify(() => dio.fetch(any())).called(1);
      verify(() => handler.resolve(any())).called(1);
    });

    test('cierra sesión si no puede refrescar el token', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );
      final handler = MockErrorInterceptorHandler();

      when(() => tokenNotifier.getRefreshToken())
          .thenAnswer((_) async => 'refresh-token');
      when(() => authController.refreshToken()).thenAnswer((_) async => null);
      when(() => authController.logout()).thenAnswer((_) async => {});
      when(() => handler.reject(any())).thenAnswer((_) async => {});

      await interceptor.onError(dioError, handler);

      verify(() => authController.logout()).called(1);
      verify(() => handler.reject(any())).called(1);
    });

    test('maneja error cuando el refresh token es null', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );
      final handler = MockErrorInterceptorHandler();

      when(() => tokenNotifier.getRefreshToken()).thenAnswer((_) async => null);
      when(() => handler.next(any())).thenAnswer((_) async => {});

      await interceptor.onError(dioError, handler);

      // Debería pasar el error al siguiente handler
      verify(() => handler.next(any())).called(1);
    });

    test('pasa el error a través si no es 401', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );
      final handler = MockErrorInterceptorHandler();

      when(() => handler.next(any())).thenAnswer((_) async => {});

      await interceptor.onError(dioError, handler);

      verify(() => handler.next(any())).called(1);
    });
  });
}
