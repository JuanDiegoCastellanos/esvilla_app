import 'package:esvilla_app/core/utils/secure_storage.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthTokenStateNotifier extends StateNotifier<AuthTokenState> {
  final SecureStorageService _storage;

  AuthTokenStateNotifier(this._storage) : super(const AuthTokenState.empty()) {
    // Cargar el token o tokens
    _loadTokens();
  }

  Future<void> _loadTokens() async {
    final accessToken = await _storage.getToken();
    final refreshToken = await _storage.getRefreshToken();
    final expiration = await _storage.getExpiration();
    final role = await _storage.getASimpleToken('ROLE');

    state = AuthTokenState(
      role: role,
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiration: expiration,
    );
  }

  Future<void> saveTokens(
      {required String accessToken,
      required String refreshToken,
      required int expiresIn,
      required String role}) async {
    await _storage.saveToken(accessToken);
    await _storage.saveRefreshToken(refreshToken);
    await _storage.saveExpiration(expiresIn);
    await _storage.saveASimpleToken('ROLE', role);

    state = AuthTokenState(
      role: role,
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiration: expiresIn,
    );
  }

  Future<void> saveAccessToken(String accessToken) async {
    await _storage.saveToken(accessToken);
    state = AuthTokenState(
      role: state.role,
      accessToken: accessToken,
      refreshToken: state.refreshToken,
      expiration: state.expiration,
    );
  }

  Future<void> clearTokens() async {
    await _storage.clearToken();
    await _storage.clearRefreshToken();
    await _storage.clearExpiration();
    await _storage.clearASimpleToken('ROLE');
    state = const AuthTokenState.empty();
  }

  /// Exponer un método para obtener el token actual almacenado
  Future<String?> getAccessToken() async {
    if (state.accessToken != null) {
      return state.accessToken; // Si ya está cargado, devolverlo
    }
    final token =
        await _storage.getToken(); // Volver a consultar si es necesario
    if (token != null) {
      state = AuthTokenState(
        accessToken: token,
        role: state.role,
        refreshToken: state.refreshToken,
        expiration: state.expiration,
      );
    }
    return state.accessToken;
  }

  Future<String> getRefreshToken() async {
    if (state.refreshToken != null) return state.refreshToken!;
    final token = await _storage.getRefreshToken();
    if (token != null) {
      state = AuthTokenState(
        accessToken: state.accessToken,
        role: state.role,
        refreshToken: token,
        expiration: state.expiration,
      );
    }
    return state.refreshToken!;
  }

  Future<String?> getRole() async {
    if (state.role != null) return state.role; // Si ya está cargado, devolverlo
    final role = await _storage
        .getASimpleToken('ROLE'); // Volver a consultar si es necesario
    if (role != null) {
      state = AuthTokenState(
        accessToken: state.accessToken,
        role: role,
        refreshToken: state.refreshToken,
        expiration: state.expiration,
      );
    }
    return state.role;
  }

  /// Valida si el token esta cerca de expirar o no
  ///
  /// Verifica si el token actual esta cerca de expirar (1 dia antes de expirar)
  /// y devuelve true si esta cerca de expirar o false en caso contrario
  bool isTokenExpiringSoon() {
    if (state.accessToken == null || state.expiration == null) return false;
    final expirationDate =
        DateTime.fromMillisecondsSinceEpoch(state.expiration!);
    return expirationDate.isBefore(DateTime.now()
        .add(const Duration(minutes: 5))); // 1 dia antes de expirar
  }

  /// Checks if the current token is expired.
  ///
  /// This function retrieves the token's expiration time from storage and
  /// compares it with the current time. Returns `true` if the token's
  /// expiration time is earlier than the current time, indicating that
  /// the token has expired; otherwise, returns `false`.
  Future<bool> isTokenExpired() async {
    final expiration = await _storage.getExpiration();
    if (expiration == null) return true;
    final expirationDate = DateTime.fromMillisecondsSinceEpoch(expiration);
    return expirationDate.isBefore(DateTime.now());
  }
}
