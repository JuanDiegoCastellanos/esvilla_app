import 'package:esvilla_app/domain/entities/auth/auth_response_entity.dart';
import 'package:esvilla_app/domain/repositories/auth_repository.dart';
import 'package:esvilla_app/domain/use_cases/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  group('LoginUseCase', () {
    test('debería hacer login exitosamente', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final expectedResponse = AuthResponseEntity(
        accessToken: 'access_token_123',
        refreshToken: 'refresh_token_123',
        role: 'user',
        expiration: 3600,
      );

      when(() => mockRepository.login(email, password))
          .thenAnswer((_) async => expectedResponse);

      // Act
      final result = await useCase.call(email, password);

      // Assert
      expect(result, equals(expectedResponse));
      verify(() => mockRepository.login(email, password)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'wrongpassword';

      when(() => mockRepository.login(email, password))
          .thenThrow(Exception('Credenciales inválidas'));

      // Act & Assert
      expect(() => useCase.call(email, password), throwsException);
      verify(() => mockRepository.login(email, password)).called(1);
    });
  });
}