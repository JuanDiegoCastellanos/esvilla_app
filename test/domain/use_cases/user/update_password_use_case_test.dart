import 'package:esvilla_app/domain/entities/user/update_password_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';
import 'package:esvilla_app/domain/use_cases/user/update_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UpdatePasswordUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = UpdatePasswordUseCase(mockRepository);
  });

  group('UpdatePasswordUseCase', () {
    test('debería actualizar contraseña exitosamente', () async {
      // Arrange
      final request = UpdatePasswordRequestEntity(
        oldPassword: 'oldPassword123',
        newPassword: 'newPassword456',
        confirmNewPassword: 'newPassword456',
      );

      final expectedUser = UserEntity(
        id: '1',
        name: 'Juan Pérez',
        documentNumber: '12345678',
        email: 'juan@example.com',
        phone: '3001234567',
        password: 'newPassword456',
        mainAddress: 'Calle 123 #45-67',
        role: 'user',
      );

      when(() => mockRepository.updateMyPassword(request))
          .thenAnswer((_) async => expectedUser);

      // Act
      final result = await useCase.call(request);

      // Assert
      expect(result, equals(expectedUser));
      verify(() => mockRepository.updateMyPassword(request)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      final request = UpdatePasswordRequestEntity(
        oldPassword: 'wrongPassword',
        newPassword: 'newPassword456',
        confirmNewPassword: 'newPassword456',
      );

      when(() => mockRepository.updateMyPassword(request))
          .thenThrow(Exception('Contraseña actual incorrecta'));

      // Act & Assert
      expect(() => useCase.call(request), throwsException);
      verify(() => mockRepository.updateMyPassword(request)).called(1);
    });
  });
}
