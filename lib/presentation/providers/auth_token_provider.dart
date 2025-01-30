import 'package:esvilla_app/core/utils/secure_storage.dart';
import 'package:esvilla_app/presentation/providers/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class AuthTokenStateNotifier extends StateNotifier<String?> {
  final SecureStorageService _storageService;

  AuthTokenStateNotifier(this._storageService) : super(null) {
    _loadToken(); // Cargar el token al iniciar
  }

  Future<void> _loadToken() async {
    state = await _storageService.getToken();
  }

  Future<void> saveToken(String token) async {
    await _storageService.saveToken(token);
    state = token;
  }

  Future<void> clearToken() async {
    await _storageService.clearToken();
    state = null;
  }
  /// Exponer un método para obtener el token actual almacenado
  Future<String?> getToken() async {
    if (state != null) return state; // Si ya está cargado, devolverlo
    state = await _storageService.getToken(); // Volver a consultar si es necesario
    return state;
  }
}

final authTokenProvider = StateNotifierProvider<AuthTokenStateNotifier, String?>(
  (ref) => AuthTokenStateNotifier(ref.watch(secureStorageServiceProvider)),
);
