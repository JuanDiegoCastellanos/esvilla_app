import 'package:esvilla_app/domain/entities/user/update_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';
import 'package:esvilla_app/domain/use_cases/user/update_my_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UpdateMyProfileUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = UpdateMyProfileUseCase(mockRepository);
  });

  group('UpdateMyProfileUseCase', () {
    test('debería actualizar mi perfil exitosamente', () async {
      // Arrange
      final request = UpdateUserRequestEntity(
        id: '1',
        name: 'Juan Carlos Pérez',
        email: 'juancarlos@example.com',
        phone: '3009876543',
      );

      final expectedUser = UserEntity(
        id: '1',
        name: 'Juan Carlos Pérez',
        documentNumber: '12345678',
        email: 'juancarlos@example.com',
        phone: '3009876543',
        password: 'password123',
        mainAddress: 'Calle 123 #45-67',
        role: 'user',
      );

      when(() => mockRepository.updateMyInfo(request))
          .thenAnswer((_) async => expectedUser);

      // Act
      final result = await useCase.call(request);

      // Assert
      expect(result, equals(expectedUser));
      verify(() => mockRepository.updateMyInfo(request)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      final request = UpdateUserRequestEntity(
        id: '1',
        name: 'Juan Carlos Pérez',
      );

      when(() => mockRepository.updateMyInfo(request))
          .thenThrow(Exception('Error al actualizar perfil'));

      // Act & Assert
      expect(() => useCase.call(request), throwsException);
      verify(() => mockRepository.updateMyInfo(request)).called(1);
    });
  });
}
