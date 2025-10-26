import 'package:esvilla_app/core/utils/secure_storage.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_state.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_state_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeStorage implements SecureStorageService {
  String? _access;
  String? _refresh;
  int? _exp;
  final Map<String, String> _kv = {};

  @override
  Future<void> clearASimpleToken(String key) async => _kv.remove(key);
  @override
  Future<void> clearExpiration() async => _exp = null;
  @override
  Future<void> clearRefreshToken() async => _refresh = null;
  @override
  Future<void> clearToken() async => _access = null;
  @override
  Future<String?> getASimpleToken(String key) async => _kv[key];
  @override
  Future<int?> getExpiration() async => _exp;
  @override
  Future<String?> getRefreshToken() async => _refresh;
  @override
  Future<String?> getToken() async => _access;
  @override
  Future<void> saveASimpleToken(String key, String value) async =>
      _kv[key] = value;
  @override
  Future<void> saveExpiration(int expiresIn) async => _exp = expiresIn;
  @override
  Future<void> saveRefreshToken(String refreshToken) async =>
      _refresh = refreshToken;
  @override
  Future<void> saveToken(String accessToken) async => _access = accessToken;
}

void main() {
  late _FakeStorage storage;
  late AuthTokenStateNotifier notifier;
  
  setUp(() {
    storage = _FakeStorage();
    notifier = AuthTokenStateNotifier(storage);
    // Establecer un estado inicial vacío para evitar problemas con loadTokens
    notifier.state = const AuthTokenState.empty();
  });
  
  test('saveTokens persiste y actualiza el estado', () async {
    // Usar un tiempo de expiración futuro para evitar que expire durante el test
    final futureTime = DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch;
    
    await notifier.saveTokens(
      accessToken: 'acc',
      refreshToken: 'ref',
      expiresIn: 3600, // 1 hora
      role: 'user',
    );

    expect(notifier.state.accessToken, 'acc');
    expect(await storage.getToken(), 'acc');
    expect(notifier.state.refreshToken, 'ref');
    expect(await storage.getRefreshToken(), 'ref');
    expect(notifier.state.role, 'user');
    expect(await storage.getASimpleToken('ROLE'), 'user');
    expect(notifier.isTokenExpired(), false);
  });

  test('clearTokens limpia storage y estado', () async {
    notifier.state = const AuthTokenState(
        accessToken: 'acc', refreshToken: 'ref', expiration: 1, role: 'user');

    await notifier.clearTokens();
    expect(notifier.state, const AuthTokenState.empty());
    expect(await storage.getToken(), isNull);
    expect(await storage.getRefreshToken(), isNull);
    expect(await storage.getASimpleToken('ROLE'), isNull);
  });
  
  test('isTokenExpired retorna true cuando el token ha expirado', () async {
    // Establecer un tiempo de expiración en el pasado
    final pastTime = DateTime.now().subtract(Duration(hours: 1)).millisecondsSinceEpoch;
    
    notifier.state = AuthTokenState(
      accessToken: 'acc', 
      refreshToken: 'ref', 
      expiration: pastTime, 
      role: 'user'
    );
    
    expect(notifier.isTokenExpired(), true);
  });
  
  test('isTokenExpiringSoon retorna true cuando el token expirará pronto', () async {
    // Establecer un tiempo de expiración en 4 minutos (dentro del umbral de 5 minutos)
    final soonTime = DateTime.now().add(Duration(minutes: 4)).millisecondsSinceEpoch;
    
    notifier.state = AuthTokenState(
      accessToken: 'acc', 
      refreshToken: 'ref', 
      expiration: soonTime, 
      role: 'user'
    );
    
    expect(notifier.isTokenExpiringSoon(), true);
  });
}
