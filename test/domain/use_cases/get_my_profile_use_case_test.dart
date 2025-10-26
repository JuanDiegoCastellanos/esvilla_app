import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';
import 'package:esvilla_app/domain/use_cases/get_my_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetMyProfileUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetMyProfileUseCase(mockRepository);
  });

  group('GetMyProfileUseCase', () {
    test('debería obtener mi perfil exitosamente', () async {
      // Arrange
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

      when(() => mockRepository.myProfile())
          .thenAnswer((_) async => expectedUser);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(expectedUser));
      verify(() => mockRepository.myProfile()).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      when(() => mockRepository.myProfile())
          .thenThrow(Exception('Usuario no autenticado'));

      // Act & Assert
      expect(() => useCase.call(), throwsException);
      verify(() => mockRepository.myProfile()).called(1);
    });
  });
}