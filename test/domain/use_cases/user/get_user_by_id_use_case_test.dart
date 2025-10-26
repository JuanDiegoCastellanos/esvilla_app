import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';
import 'package:esvilla_app/domain/use_cases/user/get_user_by_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUserByIdUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetUserByIdUseCase(mockRepository);
  });

  group('GetUserByIdUseCase', () {
    test('debería obtener un usuario por ID exitosamente', () async {
      // Arrange
      const userId = '1';
      final expectedUser = UserEntity(
        id: userId,
        name: 'Juan Pérez',
        documentNumber: '12345678',
        email: 'juan@example.com',
        phone: '3001234567',
        password: 'password123',
        mainAddress: 'Calle 123 #45-67',
        role: 'user',
      );

      when(() => mockRepository.getById(userId))
          .thenAnswer((_) async => expectedUser);

      // Act
      final result = await useCase.call(userId);

      // Assert
      expect(result, equals(expectedUser));
      verify(() => mockRepository.getById(userId)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const userId = '999';

      when(() => mockRepository.getById(userId))
          .thenThrow(Exception('Usuario no encontrado'));

      // Act & Assert
      expect(() => useCase.call(userId), throwsException);
      verify(() => mockRepository.getById(userId)).called(1);
    });
  });
}
