import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/domain/entities/auth/auth_response_entity.dart';
import 'package:esvilla_app/domain/use_cases/login_use_case.dart';
import 'package:esvilla_app/domain/use_cases/register_use_cart.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_state.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_state.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/user/user_data_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

class _MockRegisterUseCase extends Mock implements RegisterUseCase {}

class _MockUserDataNotifier extends Mock implements UserDataStateNotifier {}

class _MockRef extends Mock implements Ref {}

class _MockAuthTokenNotifier extends StateNotifier<AuthTokenState>
    implements AuthTokenStateNotifier {
  _MockAuthTokenNotifier() : super(const AuthTokenState());

  @override
  Future<void> loadTokens() async {}

  @override
  Future<void> saveTokens(
      {required String accessToken,
      required String refreshToken,
      required int expiresIn,
      required String role}) async {
    state = AuthTokenState(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiration: expiresIn,
        role: role);
  }

  @override
  Future<void> clearTokens() async {
    state = const AuthTokenState();
  }

  @override
  Future<void> saveAccessToken(String accessToken) async {}

  @override
  Future<String?> getAccessToken() async => state.accessToken;

  @override
  Future<String?> getRefreshToken() async => state.refreshToken;

  @override
  Future<String?> getRole() async => state.role;

  @override
  bool isTokenExpiringSoon({Duration threshold = const Duration(minutes: 5)}) =>
      false;

  @override
  bool isTokenExpired() => false;
}

void main() {
  late _MockLoginUseCase loginUseCase;
  late _MockRegisterUseCase registerUseCase;
  late _MockAuthTokenNotifier authTokenNotifier;
  late _MockUserDataNotifier userDataNotifier;
  late ProviderContainer container;
  late _MockRef ref;

  setUp(() {
    loginUseCase = _MockLoginUseCase();
    registerUseCase = _MockRegisterUseCase();
    authTokenNotifier = _MockAuthTokenNotifier();
    userDataNotifier = _MockUserDataNotifier();
    container = ProviderContainer();
    ref = _MockRef();
  });

  tearDown(() => container.dispose());

  group('AuthController', () {
    test('login exitoso actualiza estado y guarda tokens', () async {
      final response = AuthResponseEntity(
        accessToken: 'acc',
        refreshToken: 'ref',
        role: 'admin',
        expiration: 3600,
      );
      when(() => loginUseCase.call('a@b.com', 'pwd'))
          .thenAnswer((_) async => response);
      when(() => userDataNotifier.clearTokens()).thenAnswer((_) async {});

      final controller = AuthController(
        loginUseCase,
        registerUseCase,
        authTokenNotifier,
        userDataNotifier,
        ref,
      );
      await controller.login('a@b.com', 'pwd');

      expect(controller.state.isAuthenticated, true);
      expect(controller.state.isAdmin, true);
      expect(controller.state.token, 'acc');
      expect(controller.state.isLoading, false);
      expect(controller.state.error, null);
    });

    test('login fallido establece error', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: '/auth/login'),
        ),
      );
      when(() => loginUseCase.call('a@b.com', 'wrong'))
          .thenThrow(AppException.fromDioExceptionType(exception.type));

      final controller = AuthController(
        loginUseCase,
        registerUseCase,
        authTokenNotifier,
        userDataNotifier,
        ref,
      );
      await controller.login('a@b.com', 'wrong');

      expect(controller.state.isAuthenticated, false);
      expect(controller.state.error, 'Email o contraseña incorrectos');
      expect(controller.state.isLoading, false);
    });
  });
}
