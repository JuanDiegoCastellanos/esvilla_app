import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/domain/entities/auth/register_request_entity.dart';
import 'package:esvilla_app/domain/use_cases/login_use_case.dart';
import 'package:esvilla_app/domain/use_cases/register_use_cart.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_repository_provider.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_state.dart';
import 'package:esvilla_app/presentation/providers/auth/login_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/auth/register_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/user/user_data_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final AuthTokenStateNotifier _authTokenStateNotifier;
  final UserDataStateNotifier _userDataStateNotifier;
  final Ref _ref;

  // Variable para evitar refresh simultáneos
  Future<String?>? _refreshingFuture;

  AuthController(
    this._loginUseCase,
    this._registerUseCase,
    this._authTokenStateNotifier,
    this._userDataStateNotifier,
    this._ref,
  ) : super(AuthState(token: '')) {
    //checkAuthentication();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _loginUseCase(email, password);

      if (response.accessToken.isEmpty) {
        throw Exception("Token vacío, login fallido");
      }

      await _authTokenStateNotifier.clearTokens();
      await _userDataStateNotifier.clearTokens();
      await _authTokenStateNotifier.saveTokens(
        role: response.role,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresIn: response.expiration,
      );
      state = AuthState(
          token: response.accessToken,
          isAdmin: response.role == 'admin',
          isAuthenticated: true,
          isLoading: false,
          error: null);
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.code == 401 ? 'Email o contraseña incorrectos' : e.message,
      );
    }
  }

  Future<void> register(String name, String document, String email,
      String phone, String password, String direccion) async {
    state = AuthState(
        isLoading: true,
        error: null,
        isAdmin: false,
        isAuthenticated: false,
        token: '');
    try {
      final response = await _registerUseCase(RegisterRequestEntity(
          name: name,
          document: document,
          email: email,
          phone: phone,
          password: password,
          direccion: direccion));

      await _authTokenStateNotifier.clearTokens();
      await _userDataStateNotifier.clearTokens();
      await _authTokenStateNotifier.saveTokens(
        role: response.role,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresIn: response.expiration,
      );

      state = AuthState(
          token: response.accessToken,
          isLoading: false,
          error: null,
          isAdmin: response.role == 'admin',
          isAuthenticated: true);
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
    final isExpired = _authTokenStateNotifier.isTokenExpired();
    if (storedToken != null && !isExpired) {
      state = state.copyWith(
        token: storedToken,
        isAdmin: storedRole == 'admin',
        isAuthenticated: true,
        isLoading: false,
      );
    } else {
      logout();
    }
  }

  Future<void> logout() async {
    await _authTokenStateNotifier.clearTokens();
    await _userDataStateNotifier.clearTokens();
    state = AuthState(token: '', isAuthenticated: false);
  }

  Future<String?> refreshToken() async {
    if (_refreshingFuture != null) {
      return _refreshingFuture;
    }
    try {
      _refreshingFuture = _performRefreshToken();
      return await _refreshingFuture;
    } finally {
      _refreshingFuture = null;
    }
  }

  Future<String?> _performRefreshToken() async {
    try {
      final refreshToken = _authTokenStateNotifier.state.refreshToken;
      if (refreshToken == null) {
        await logout();
        return null;
      }
      // 1. Llamar al repositorio para refrescar el token
      final newTokens =
          await _ref.read(authRepositoryProvider).refreshToken(refreshToken);

      // 2. Guardar tokens con expiresIn en segundos (no timestamp)
      await _authTokenStateNotifier.saveTokens(
        role: newTokens.role,
        accessToken: newTokens.accessToken,
        refreshToken: newTokens.refreshToken,
        expiresIn: newTokens.expiration,
      );

      // 4. Actualizar AuthState
      state = state.copyWith(
          token: newTokens.accessToken,
          isAdmin: newTokens.role == 'admin',
          isAuthenticated: true);

      return newTokens.accessToken;
    } catch (e) {
      AppLogger.e("Error refreshing token ----xxxx : $e");
      await logout();
      return null;
    }
  }

  // Este método actualiza los tokens en el estado y en el storage.
  Future<void> updateTokenFromRefresh(
      {required String newAccessToken,
      required String newRefreshToken,
      required int newExpiration}) async {
    // Actualiza en el storage, etc.
    await _authTokenStateNotifier.saveTokens(
      role: state.isAdmin ? 'admin' : 'user', // O bien usa el role recibido
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      expiresIn: newExpiration,
    );
    // Actualiza el estado
    state = state.copyWith(token: newAccessToken);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final registerUserCase = ref.watch(registerUseCaseProvider);
    final loginUseCase = ref.watch(loginUseCaseProvider);
    final userDataSN = ref.watch(userDataProvider.notifier);
    final authTokenStateNotifier =
        ref.watch(authTokenStateNotifierProvider.notifier);
    return AuthController(loginUseCase, registerUserCase,
        authTokenStateNotifier, userDataSN, ref);
  },
);
