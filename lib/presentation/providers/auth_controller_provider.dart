import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/domain/use_cases/login_use_case.dart';
import 'package:esvilla_app/presentation/providers/auth_provider.dart';
import 'package:esvilla_app/presentation/providers/auth_token_provider.dart';
import 'package:esvilla_app/presentation/providers/login_use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final String token;
  final bool isAdmin;
  final bool isLoading;
  final String? error;

  AuthState({
    this.token = '',
    this.isAdmin = false,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => token.isNotEmpty;

  //copyWith
  AuthState copyWith({
    String? token,
    bool? isAdmin,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      token: token ?? this.token,
      isAdmin: isAdmin ?? this.isAdmin,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final AuthTokenStateNotifier _authTokenStateNotifier;
  final Ref _ref;

  AuthController(
    this._loginUseCase,
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
    } catch (e) {
      state = state.copyWith(error: e.toString());
      AppLogger.e("Login failed: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> checkAuthentication() async {
    final storedToken = await _authTokenStateNotifier.getAccessToken();
    if (storedToken != null && storedToken.isNotEmpty) {
      state = state.copyWith(
          token: storedToken,
          isAdmin: _authTokenStateNotifier.state.role == 'admin');
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
    final loginUseCase = ref.watch(loginUseCaseProvider);
    final authTokenStateNotifier = ref.watch(authTokenProvider.notifier);
    return AuthController(loginUseCase, authTokenStateNotifier, ref);
  },
);
