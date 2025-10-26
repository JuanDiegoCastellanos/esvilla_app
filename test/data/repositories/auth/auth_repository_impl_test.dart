import 'package:esvilla_app/data/datasources/auth/auth_local_data_source.dart';
import 'package:esvilla_app/data/datasources/auth/auth_remote_data_source.dart';
import 'package:esvilla_app/data/models/auth/auth_response.dart';
import 'package:esvilla_app/data/repositories/auth/auth_repository_impl.dart';
import 'package:esvilla_app/domain/entities/auth/auth_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  group('AuthLocalRepositoryImpl', () {
    late AuthLocalRepositoryImpl repository;
    late MockAuthLocalDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockAuthLocalDataSource();
      repository = AuthLocalRepositoryImpl(mockDataSource);
    });

    group('login', () {
      test('debería hacer login exitosamente', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        final authResponse = AuthResponse(
          accessToken: 'access_token_123',
          role: 'user',
          refreshToken: 'refresh_token_123',
          expiresIn: 3600,
        );

        when(() => mockDataSource.login(email, password))
            .thenAnswer((_) async => authResponse);

        // Act
        final result = await repository.login(email, password);

        // Assert
        expect(result.accessToken, equals('access_token_123'));
        expect(result.refreshToken, equals('refresh_token_123'));
        expect(result.role, equals('user'));
        expect(result.expiration, equals(3600));
        verify(() => mockDataSource.login(email, password)).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrongpassword';

        when(() => mockDataSource.login(email, password))
            .thenThrow(Exception('Credenciales inválidas'));

        // Act & Assert
        expect(() => repository.login(email, password), throwsException);
        verify(() => mockDataSource.login(email, password)).called(1);
      });
    });

    group('refreshToken', () {
      test('debería lanzar UnimplementedError', () async {
        // Arrange
        const refreshToken = 'refresh_token_123';

        // Act & Assert
        expect(() => repository.refreshToken(refreshToken), throwsA(isA<UnimplementedError>()));
      });
    });
  });

  group('AuthRemoteRepositoryImpl', () {
    late AuthRemoteRepositoryImpl repository;
    late MockAuthRemoteDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockAuthRemoteDataSource();
      repository = AuthRemoteRepositoryImpl(mockDataSource);
    });

    group('login', () {
      test('debería hacer login exitosamente', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        final authResponse = AuthResponse(
          accessToken: 'access_token_123',
          role: 'user',
          refreshToken: 'refresh_token_123',
          expiresIn: 3600,
        );

        when(() => mockDataSource.login(email, password))
            .thenAnswer((_) async => authResponse);

        // Act
        final result = await repository.login(email, password);

        // Assert
        expect(result.accessToken, equals('access_token_123'));
        expect(result.refreshToken, equals('refresh_token_123'));
        expect(result.role, equals('user'));
        expect(result.expiration, equals(3600));
        verify(() => mockDataSource.login(email, password)).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrongpassword';

        when(() => mockDataSource.login(email, password))
            .thenThrow(Exception('Credenciales inválidas'));

        // Act & Assert
        expect(() => repository.login(email, password), throwsException);
        verify(() => mockDataSource.login(email, password)).called(1);
      });
    });

    group('refreshToken', () {
      test('debería refrescar token exitosamente', () async {
        // Arrange
        const refreshToken = 'refresh_token_123';
        final authResponse = AuthResponse(
          accessToken: 'new_access_token_123',
          role: 'user',
          refreshToken: 'new_refresh_token_123',
          expiresIn: 3600,
        );

        when(() => mockDataSource.refreshToken(refreshToken))
            .thenAnswer((_) async => authResponse);

        // Act
        final result = await repository.refreshToken(refreshToken);

        // Assert
        expect(result.accessToken, equals('new_access_token_123'));
        expect(result.refreshToken, equals('new_refresh_token_123'));
        expect(result.role, equals('user'));
        expect(result.expiration, equals(3600));
        verify(() => mockDataSource.refreshToken(refreshToken)).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        const refreshToken = 'invalid_refresh_token';

        when(() => mockDataSource.refreshToken(refreshToken))
            .thenThrow(Exception('Token de refresh inválido'));

        // Act & Assert
        expect(() => repository.refreshToken(refreshToken), throwsException);
        verify(() => mockDataSource.refreshToken(refreshToken)).called(1);
      });
    });
  });
}
