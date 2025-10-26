import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';
import 'package:esvilla_app/domain/use_cases/pqrs/get_pqrs_by_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPqrsRepository extends Mock implements PqrsRepository {}

void main() {
  late GetPqrsByIdUseCase useCase;
  late MockPqrsRepository mockRepository;

  setUp(() {
    mockRepository = MockPqrsRepository();
    useCase = GetPqrsByIdUseCase(mockRepository);
  });

  group('GetPqrsByIdUseCase', () {
    test('debería obtener un PQRS por ID exitosamente', () async {
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

      when(() => mockRepository.getById(pqrsId))
          .thenAnswer((_) async => expectedPqrs);

      // Act
      final result = await useCase.call(pqrsId);

      // Assert
      expect(result, equals(expectedPqrs));
      verify(() => mockRepository.getById(pqrsId)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const pqrsId = '999';

      when(() => mockRepository.getById(pqrsId))
          .thenThrow(Exception('PQRS no encontrado'));

      // Act & Assert
      expect(() => useCase.call(pqrsId), throwsException);
      verify(() => mockRepository.getById(pqrsId)).called(1);
    });
  });
}
