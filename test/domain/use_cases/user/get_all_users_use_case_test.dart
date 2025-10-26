import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';
import 'package:esvilla_app/domain/use_cases/user/get_all_users_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetAllUsersUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetAllUsersUseCase(mockRepository);
  });

  group('GetAllUsersUseCase', () {
    test('debería obtener todos los usuarios exitosamente', () async {
      // Arrange
      final expectedUsers = [
        UserEntity(
          id: '1',
          name: 'Juan Pérez',
          documentNumber: '12345678',
          email: 'juan@example.com',
          phone: '3001234567',
          password: 'password123',
          mainAddress: 'Calle 123 #45-67',
          role: 'user',
        ),
        UserEntity(
          id: '2',
          name: 'María García',
          documentNumber: '87654321',
          email: 'maria@example.com',
          phone: '3007654321',
          password: 'password456',
          mainAddress: 'Calle 456 #78-90',
          role: 'admin',
        ),
      ];

      when(() => mockRepository.getAll())
          .thenAnswer((_) async => expectedUsers);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(expectedUsers));
      expect(result.length, equals(2));
      verify(() => mockRepository.getAll()).called(1);
    });

    test('debería retornar lista vacía cuando no hay usuarios', () async {
      // Arrange
      when(() => mockRepository.getAll())
          .thenAnswer((_) async => <UserEntity>[]);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getAll()).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      when(() => mockRepository.getAll())
          .thenThrow(Exception('Error del servidor'));

      // Act & Assert
      expect(() => useCase.call(), throwsException);
      verify(() => mockRepository.getAll()).called(1);
    });
  });
}
