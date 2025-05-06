import 'package:esvilla_app/core/utils/secure_storage.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_state.dart';
import 'package:esvilla_app/presentation/providers/storage/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthTokenStateNotifier extends StateNotifier<AuthTokenState> {
  final SecureStorageService _storage;

  AuthTokenStateNotifier(this._storage) : super(const AuthTokenState.empty()) {
    loadTokens();
  }

  Future<void> loadTokens() async {
    try {
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
    } catch (e) {
      state = const AuthTokenState.empty();
      rethrow;
    }
  }

  Future<void> saveTokens(
      {required String accessToken,
      required String refreshToken,
      required int expiresIn,
      required String role}) async {
    try {
      final expirationTime = DateTime.now()
          .add(Duration(seconds: expiresIn))
          .millisecondsSinceEpoch;

      await Future.wait([
        _storage.saveToken(accessToken),
        _storage.saveRefreshToken(refreshToken),
        _storage.saveExpiration(expirationTime),
        _storage.saveASimpleToken('ROLE', role),
      ]);

      state = AuthTokenState(
        role: role,
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiration: expirationTime,
      );
    } catch (e) {
      await _storage.clearToken();
      await _storage.clearRefreshToken();
      await _storage.clearExpiration();
      await _storage.clearASimpleToken('ROLE');
      rethrow;
    }
  }

  Future<void> saveAccessToken(String accessToken) async {
    try {
      await _storage.saveToken(accessToken);
      state = state.copyWith(accessToken: accessToken);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.clearToken(),
      _storage.clearRefreshToken(),
      _storage.clearExpiration(),
      _storage.clearASimpleToken('ROLE'),
    ]);
    state = const AuthTokenState.empty();
  }

  Future<String?> getAccessToken() async {
    if (state.accessToken != null) return state.accessToken;

    try {
      final token = await _storage.getToken();
      if (token != null) {
        state = state.copyWith(accessToken: token);
      }
      return token;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getRefreshToken() async {
    if (state.refreshToken != null) return state.refreshToken;

    try {
      final token = await _storage.getRefreshToken();
      if (token != null) {
        state = state.copyWith(refreshToken: token);
      }
      return token;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getRole() async {
    if (state.role != null) return state.role;

    try {
      final role = await _storage.getASimpleToken('ROLE');
      if (role != null) {
        state = state.copyWith(role: role);
      }
      return role;
    } catch (e) {
      rethrow;
    }
  }

  bool isTokenExpiringSoon({Duration threshold = const Duration(minutes: 5)}) {
    if (state.expiration == null) return false;

    final expirationDate =
        DateTime.fromMillisecondsSinceEpoch(state.expiration!);
    return expirationDate.isBefore(DateTime.now().add(threshold));
  }

  bool isTokenExpired() {
    if (state.expiration == null) return true;

    final expirationDate =
        DateTime.fromMillisecondsSinceEpoch(state.expiration!);
    return expirationDate.isBefore(DateTime.now());
  }
}

final authTokenStateNotifierProvider =
    StateNotifierProvider<AuthTokenStateNotifier, AuthTokenState>(
  (ref) => AuthTokenStateNotifier(ref.watch(secureStorageServiceProvider)),
);
