import 'package:esvilla_app/core/utils/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late SecureStorageServiceImpl storageService;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    // Configurar default stubs para métodos void
    when(() => mockStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenAnswer((_) async => {});
    when(() => mockStorage.delete(key: any(named: 'key')))
        .thenAnswer((_) async => {});
    storageService = SecureStorageServiceImpl(mockStorage);
  });

  group('SecureStorageServiceImpl', () {
    group('saveToken', () {
      test('guarda el token de acceso correctamente', () async {
        await storageService.saveToken('test-token');
        verify(() =>
                mockStorage.write(key: 'ACCESS_TOKEN', value: 'test-token'))
            .called(1);
      });
    });

    group('saveRefreshToken', () {
      test('guarda el token de refresco correctamente', () async {
        await storageService.saveRefreshToken('refresh-token');
        verify(() =>
                mockStorage.write(key: 'REFRESH_TOKEN', value: 'refresh-token'))
            .called(1);
      });
    });

    group('saveExpiration', () {
      test('guarda la expiración correctamente', () async {
        await storageService.saveExpiration(3600);
        verify(() => mockStorage.write(key: 'EXPIRES_IN', value: '3600'))
            .called(1);
      });
    });

    group('getToken', () {
      test('obtiene el token de acceso correctamente', () async {
        when(() => mockStorage.read(key: 'ACCESS_TOKEN'))
            .thenAnswer((_) async => 'test-token');
        final token = await storageService.getToken();
        expect(token, 'test-token');
      });
    });

    group('getRefreshToken', () {
      test('obtiene el token de refresco correctamente', () async {
        when(() => mockStorage.read(key: 'REFRESH_TOKEN'))
            .thenAnswer((_) async => 'refresh-token');
        final token = await storageService.getRefreshToken();
        expect(token, 'refresh-token');
      });
    });

    group('getExpiration', () {
      test('obtiene la expiración correctamente', () async {
        when(() => mockStorage.read(key: 'EXPIRES_IN'))
            .thenAnswer((_) async => '3600');
        final expiration = await storageService.getExpiration();
        expect(expiration, 3600);
      });

      test('retorna 0 si no hay expiración guardada', () async {
        when(() => mockStorage.read(key: 'EXPIRES_IN'))
            .thenAnswer((_) async => null);
        final expiration = await storageService.getExpiration();
        expect(expiration, 0);
      });
    });

    group('clearToken', () {
      test('elimina el token de acceso correctamente', () async {
        await storageService.clearToken();
        verify(() => mockStorage.delete(key: 'ACCESS_TOKEN')).called(1);
      });
    });

    group('clearRefreshToken', () {
      test('elimina el token de refresco correctamente', () async {
        await storageService.clearRefreshToken();
        verify(() => mockStorage.delete(key: 'REFRESH_TOKEN')).called(1);
      });
    });

    group('clearExpiration', () {
      test('elimina la expiración correctamente', () async {
        await storageService.clearExpiration();
        verify(() => mockStorage.delete(key: 'EXPIRES_IN')).called(1);
      });
    });

    group('saveASimpleToken', () {
      test('guarda un token simple correctamente', () async {
        await storageService.saveASimpleToken('TEST_KEY', 'test-value');
        verify(() => mockStorage.write(key: 'TEST_KEY', value: 'test-value'))
            .called(1);
      });
    });

    group('getASimpleToken', () {
      test('obtiene un token simple correctamente', () async {
        when(() => mockStorage.read(key: 'TEST_KEY'))
            .thenAnswer((_) async => 'test-value');
        final value = await storageService.getASimpleToken('TEST_KEY');
        expect(value, 'test-value');
      });
    });

    group('clearASimpleToken', () {
      test('elimina un token simple correctamente', () async {
        await storageService.clearASimpleToken('TEST_KEY');
        verify(() => mockStorage.delete(key: 'TEST_KEY')).called(1);
      });
    });
  });
}
