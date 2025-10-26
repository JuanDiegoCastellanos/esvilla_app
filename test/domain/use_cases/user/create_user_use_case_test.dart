import 'package:esvilla_app/domain/entities/user/create_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';
import 'package:esvilla_app/domain/use_cases/user/create_user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late CreateUserUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = CreateUserUseCase(mockRepository);
  });

  group('CreateUserUseCase', () {
    test('debería crear un usuario exitosamente', () async {
      // Arrange
      final request = CreateUserRequestEntity(
        name: 'Juan Pérez',
        documentNumber: '12345678',
        email: 'juan@example.com',
        phone: '3001234567',
        password: 'password123',
        mainAddress: 'Calle 123 #45-67',
        role: 'user',
      );

      final expectedUser = UserEntity(
        id: '1',
        name: 'Juan Pérez',
        documentNumber: '12345678',
        email: 'juan@example.com',
        phone: '3001234567',
        password: 'password123',
        mainAddress: 'Calle 123 #45-67',
        role: 'user',
      );

      when(() => mockRepository.add(request))
          .thenAnswer((_) async => expectedUser);

      // Act
      final result = await useCase.call(request);

      // Assert
      expect(result, equals(expectedUser));
      verify(() => mockRepository.add(request)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      final request = CreateUserRequestEntity(
        name: 'Juan Pérez',
        documentNumber: '12345678',
        email: 'juan@example.com',
        phone: '3001234567',
        password: 'password123',
        mainAddress: 'Calle 123 #45-67',
        role: 'user',
      );

      when(() => mockRepository.add(request))
          .thenThrow(Exception('Error del servidor'));

      // Act & Assert
      expect(() => useCase.call(request), throwsException);
      verify(() => mockRepository.add(request)).called(1);
    });
  });
}
