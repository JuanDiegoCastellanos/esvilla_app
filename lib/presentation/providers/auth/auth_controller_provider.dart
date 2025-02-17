import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/domain/entities/register_request_entity.dart';
import 'package:esvilla_app/domain/use_cases/login_use_case.dart';
import 'package:esvilla_app/domain/use_cases/register_use_cart.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_repository_provider.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_provider.dart';
import 'package:esvilla_app/presentation/providers/login_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/register/register_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/states/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final AuthTokenStateNotifier _authTokenStateNotifier;
  final Ref _ref;

  AuthController(
    this._loginUseCase,
    this._registerUseCase,
    this._authTokenStateNotifier,
    this._ref,
  ) : super(AuthState(token: '')) {
    checkAuthentication();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _loginUseCase(email, password);
      AppLogger.i("Login response: ${response.accessToken} - ${response.role}");

      if (response.accessToken.isEmpty) {
        throw Exception("Token vacío, login fallido");
      }

      await _authTokenStateNotifier.saveTokens(
        role: response.role,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresIn: response.expiration,
      );
      state = AuthState(
        token: response.accessToken,
        isAdmin: response.role == 'admin',
      );
      AppLogger.i(
          "AuthState : $state.isAdmin: ${state.isAdmin} - ${state.token}");
    } on AppException catch (e) {
      state = state.copyWith(error: e.message);
      AppLogger.e("Login failed: ${e.message}");
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> register(String name, String document, String email,
      String phone, String password, String direccion) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _registerUseCase(RegisterRequestEntity(
          name: name,
          document: document,
          email: email,
          phone: phone,
          password: password,
          direccion: direccion
          ));
      //hacer login si el accessToken es 


      AppLogger.i("Response response: ${response.accessToken} - ${response.role}");

      await _authTokenStateNotifier.saveTokens(
        role: response.role,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresIn: response.expiration,
      );

      state = AuthState(
        token: response.accessToken,
        isAdmin: response.role == 'admin',
      );

      AppLogger.i(
          "AuthState : $state.isAdmin: ${state.isAdmin} - ${state.token}");

    } on AppException catch (e) {
      state = state.copyWith(error: e.message);
      AppLogger.e("Login failed: ${e.message}");
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }


  Future<void> checkAuthentication() async {
    final storedToken = await _authTokenStateNotifier.getAccessToken();
    final storedRole = await _authTokenStateNotifier.getRole();
    if (storedToken != null && storedToken.isNotEmpty) {
      state = state.copyWith(
          token: storedToken,
          isAdmin: storedRole == 'admin',
      );
    }
  }

  void logout() async {
    await _authTokenStateNotifier.clearTokens();
    state = AuthState(token: '');
  }

  Future<String?> refreshToken() async {
    try {
      final refreshToken = _authTokenStateNotifier.state.refreshToken;
      if (refreshToken == null) return null;
      // Implementar lógica de refresh token aquí
      // Verificar si el token esta cerca de expirar
      final isCloseToExpire = _authTokenStateNotifier.validationToken();
      if (isCloseToExpire) {
        // Si esta cerca de expirar, refrescar el token
        AppLogger.i("Refresh token because it is close to expire");
        final newTokens =
            await _ref.read(authRepositoryProvider).refreshToken(refreshToken);
        await _authTokenStateNotifier.saveTokens(
          role: newTokens.role,
          accessToken: newTokens.accessToken,
          refreshToken: newTokens.refreshToken,
          expiresIn: newTokens.expiration,
        );
        return newTokens.accessToken;
      }
      return _authTokenStateNotifier.state.accessToken;
    } catch (e) {
      logout();
      return null;
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final registerUserCase = ref.watch(registerUseCaseProvider);
    final loginUseCase = ref.watch(loginUseCaseProvider);
    final authTokenStateNotifier = ref.watch(authTokenProvider.notifier);
    return AuthController(loginUseCase, registerUserCase,  authTokenStateNotifier, ref);
  },
);
