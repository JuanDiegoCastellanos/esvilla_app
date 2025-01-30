import 'package:esvilla_app/domain/use_cases/login_use_case.dart';
import 'package:esvilla_app/presentation/providers/auth_token_provider.dart';
import 'package:esvilla_app/presentation/providers/login_use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState{
  final String token;
  bool isAdmin;
  final bool isAuthenticated;
  AuthState({required this.token, this.isAdmin = false}): isAuthenticated = token.isNotEmpty;
}


class AuthController extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final AuthTokenStateNotifier  _authTokenStateNotifier;
  
  AuthController(this._loginUseCase, this._authTokenStateNotifier): super(AuthState(token: ''));

  Future<void> login(String email, String password) async {
    try {
      final response = await _loginUseCase(email, password);
      // actualiza el estado
      state = AuthState(
        token: response.accessToken,
        isAdmin: response.role == 'admin');
      
      await _authTokenStateNotifier.saveToken(response.accessToken);


    } catch (e) {
      state = AuthState(token: '');
      throw Exception("Login failed: $e");
    }
  }
  Future<void> checkAuthentication() async {
    final storedToken = await _authTokenStateNotifier.getToken();
    if (storedToken != null && storedToken.isNotEmpty) {
      state = AuthState(token: storedToken);
    }
  }
  void logout() async {
    await _authTokenStateNotifier.clearToken();
    state = AuthState(token: '');
  }  
}

// Proveedor del controlador de autenticación
final authControllerProvider = 
StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final loginUseCase = ref.watch(loginUseCaseProvider);
    final authTokenStateNotifier  = ref.watch(authTokenProvider.notifier);
    return AuthController(loginUseCase, authTokenStateNotifier);
  }
  );