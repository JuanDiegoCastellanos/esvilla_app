import 'package:esvilla_app/domain/entities/user/update_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';
import 'package:esvilla_app/domain/use_cases/user/update_user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UpdateUserUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = UpdateUserUseCase(mockRepository);
  });

  group('UpdateUserUseCase', () {
    test('debería actualizar un usuario exitosamente', () async {
      // Arrange
      const userId = '1';
      final request = UpdateUserRequestEntity(
        id: userId,
        name: 'Juan Carlos Pérez',
        email: 'juancarlos@example.com',
        phone: '3009876543',
      );

      final expectedUser = UserEntity(
        id: userId,
        name: 'Juan Carlos Pérez',
        documentNumber: '12345678',
        email: 'juancarlos@example.com',
        phone: '3009876543',
        password: 'password123',
        mainAddress: 'Calle 123 #45-67',
        role: 'user',
      );

      when(() => mockRepository.update(userId, request))
          .thenAnswer((_) async => expectedUser);

      // Act
      final result = await useCase.call(userId, request);

      // Assert
      expect(result, equals(expectedUser));
      verify(() => mockRepository.update(userId, request)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const userId = '1';
      final request = UpdateUserRequestEntity(
        id: userId,
        name: 'Juan Carlos Pérez',
      );

      when(() => mockRepository.update(userId, request))
          .thenThrow(Exception('Usuario no encontrado'));

      // Act & Assert
      expect(() => useCase.call(userId, request), throwsException);
      verify(() => mockRepository.update(userId, request)).called(1);
    });
  });
}
