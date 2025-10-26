import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';
import 'package:esvilla_app/domain/use_cases/pqrs/delete_pqrs_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPqrsRepository extends Mock implements PqrsRepository {}

void main() {
  late DeletePqrsUseCase useCase;
  late MockPqrsRepository mockRepository;

  setUp(() {
    mockRepository = MockPqrsRepository();
    useCase = DeletePqrsUseCase(mockRepository);
  });

  group('DeletePqrsUseCase', () {
    test('debería eliminar un PQRS exitosamente', () async {
      // Arrange
      const pqrsId = '1';
      final now = DateTime.now();
      final expectedPqrs = PqrsEntity(
        id: pqrsId,
        subject: 'Consulta sobre servicios',
        description: 'Necesito información sobre los servicios disponibles',
        radicadorId: 'user123',
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
      );

      when(() => mockRepository.delete(pqrsId))
          .thenAnswer((_) async => expectedPqrs);

      // Act
      final result = await useCase.call(pqrsId);

      // Assert
      expect(result, equals(expectedPqrs));
      verify(() => mockRepository.delete(pqrsId)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const pqrsId = '999';

      when(() => mockRepository.delete(pqrsId))
          .thenThrow(Exception('PQRS no encontrado'));

      // Act & Assert
      expect(() => useCase.call(pqrsId), throwsException);
      verify(() => mockRepository.delete(pqrsId)).called(1);
    });
  });
}
