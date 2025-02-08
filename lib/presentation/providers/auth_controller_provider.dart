import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/domain/use_cases/login_use_case.dart';
import 'package:esvilla_app/presentation/providers/auth_provider.dart';
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
  final Ref _ref;
  
  AuthController(this._loginUseCase, this._authTokenStateNotifier, this._ref): super(AuthState(token: '')){
    checkAuthentication();
  }

  /// Inicia sesion con un usuario y contraseña.
  ///
  /// Si el login es exitoso, se guarda el token de acceso y se
  /// actualiza el estado de autenticacion.
  ///
  /// Si el login falla, se cierra la sesion y se lanza una excepci n.
  ///
  /// [email] es el correo electronico del usuario.
  /// [password] es la contrasena del usuario.
  Future<void> login(String email, String password) async {
    try {
      final response = await _loginUseCase(email, password);
      AppLogger.t("Login response: ${response.accessToken} - ${response.role}");
            
      await _authTokenStateNotifier.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresIn: response.expiration
        );
      // actualiza el estado
      state = AuthState(
        token: response.accessToken,
        isAdmin: response.role == 'admin');
      AppLogger.t("AuthState : $state.isAdmin: ${state.isAdmin} - ${state.token}");


    } catch (e) {
      state = AuthState(token: '');
      AppLogger.e("Login failed: $e");
      throw Exception("Login failed: $e");
    }
  }

  /// Verifica si hay un token de acceso guardado y si es as ,
  /// actualiza el estado de autenticaci n.
  Future<void> checkAuthentication() async {
    final storedToken = await _authTokenStateNotifier.getAccessToken();
    if (storedToken != null && storedToken.isNotEmpty) {
      state = AuthState(token: storedToken);
    }
}

  /// Cierra la sesion actual, borra el token de acceso y notifica
  /// al estado de autenticacion que no esta  autenticado.
  void logout() async {
    await _authTokenStateNotifier.clearTokens();
    state = AuthState(token: '');
  }  

  /// Refresca el token de acceso si esta cerca de expirar o no se ha
  /// proporcionado un token de acceso.
  ///
  /// Si el token de acceso no se ha proporcionado, se devuelve null.
  ///
  /// Si el token de acceso esta cerca de expirar, se refresca el token
  /// y se devuelve el nuevo token de acceso.
  ///
  /// Si el token de acceso no esta cerca de expirar, se devuelve el
  /// token de acceso actual.
  ///
  /// En caso de error, se cierra la sesión y se devuelve null.
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
        final newTokens = await _ref.read(authRepositoryProvider).refreshToken(refreshToken);
        await _authTokenStateNotifier.saveTokens(
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

// Proveedor del controlador de autenticación
/// Proveedor del controlador de autenticación.
///
/// Este proveedor devuelve un [AuthController] que gestiona la autenticación
/// del usuario. El [AuthController] utiliza el [LoginUseCase] para realizar
/// el login y el [AuthTokenStateNotifier] para almacenar y obtener el token
/// de acceso.
///
/// El proveedor se encarga de instanciar el [AuthController] con los
/// parámetros necesarios y de proporcionarlo como un [StateNotifier]
/// que se puede utilizar en los widgets.
final authControllerProvider = 
StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final loginUseCase = ref.watch(loginUseCaseProvider);
    final authTokenStateNotifier  = ref.watch(authTokenProvider.notifier);
    return AuthController(loginUseCase, authTokenStateNotifier, ref);
  }
  );
