import 'package:esvilla_app/domain/use_cases/login_use_case.dart';
import 'package:esvilla_app/presentation/providers/login_use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState{
  final String token;
  final bool isAuthenticated;
  AuthState({required this.token}): isAuthenticated = token.isNotEmpty;
}


class AuthController extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  
  AuthController(this._loginUseCase): super(AuthState(token: ''));

  Future<void> login(String email, String password) async {
    try {
      final token = await _loginUseCase.call(email, password);
      state = AuthState(token: token);
    } catch (e) {
      state = AuthState(token: '');
      throw Exception("Login failed: $e");
    }
  }

  void logout() {
    state = AuthState(token: '');
  }  
}

// Proveedor del controlador de autenticación
final authControllerProvider = 
StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final loginUseCase = ref.watch(loginUseCaseProvider);
    return AuthController(loginUseCase);
  }
  );