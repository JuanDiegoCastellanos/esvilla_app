import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';
import 'package:esvilla_app/domain/use_cases/pqrs/get_pqrs_by_user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPqrsRepository extends Mock implements PqrsRepository {}

void main() {
  late GetPqrsByUserUseCase useCase;
  late MockPqrsRepository mockRepository;

  setUp(() {
    mockRepository = MockPqrsRepository();
    useCase = GetPqrsByUserUseCase(mockRepository);
  });

  group('GetPqrsByUserUseCase', () {
    test('debería obtener PQRS por usuario exitosamente', () async {
      // Arrange
      const userId = 'user123';
      final now = DateTime.now();
      final expectedPqrsList = [
        PqrsEntity(
          id: '1',
          subject: 'Consulta sobre servicios',
          description: 'Necesito información sobre los servicios disponibles',
          radicadorId: userId,
          radicadorName: 'Juan Pérez',
          radicadorPhone: '3001234567',
          radicadorEmail: 'juan@example.com',
          radicadorDocument: '12345678',
          status: PqrsStatusEnum.pendiente,
          createdAt: now,
          updatedAt: now,
          closureDate: null,
          resolution: null,
          resolverName: null,
        ),
        PqrsEntity(
          id: '2',
          subject: 'Reclamo por servicio',
          description: 'El servicio no funcionó correctamente',
          radicadorId: userId,
          radicadorName: 'Juan Pérez',
          radicadorPhone: '3001234567',
          radicadorEmail: 'juan@example.com',
          radicadorDocument: '12345678',
          status: PqrsStatusEnum.EnProceso,
          createdAt: now,
          updatedAt: now,
          closureDate: null,
          resolution: null,
          resolverName: null,
        ),
      ];

      when(() => mockRepository.getPqrsByUser(userId))
          .thenAnswer((_) async => expectedPqrsList);

      // Act
      final result = await useCase.call(userId);

      // Assert
      expect(result, equals(expectedPqrsList));
      expect(result.length, equals(2));
      verify(() => mockRepository.getPqrsByUser(userId)).called(1);
    });

    test('debería retornar lista vacía cuando el usuario no tiene PQRS', () async {
      // Arrange
      const userId = 'user999';

      when(() => mockRepository.getPqrsByUser(userId))
          .thenAnswer((_) async => <PqrsEntity>[]);

      // Act
      final result = await useCase.call(userId);

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getPqrsByUser(userId)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const userId = 'user123';

      when(() => mockRepository.getPqrsByUser(userId))
          .thenThrow(Exception('Error del servidor'));

      // Act & Assert
      expect(() => useCase.call(userId), throwsException);
      verify(() => mockRepository.getPqrsByUser(userId)).called(1);
    });
  });
}
