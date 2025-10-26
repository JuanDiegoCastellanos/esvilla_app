import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/entities/pqrs/update_pqrs_request_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';
import 'package:esvilla_app/domain/use_cases/pqrs/update_pqrs_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPqrsRepository extends Mock implements PqrsRepository {}

void main() {
  late UpdatePqrsUseCase useCase;
  late MockPqrsRepository mockRepository;

  setUp(() {
    mockRepository = MockPqrsRepository();
    useCase = UpdatePqrsUseCase(mockRepository);
  });

  group('UpdatePqrsUseCase', () {
    test('debería actualizar un PQRS exitosamente', () async {
      // Arrange
      const pqrsId = '1';
      final request = UpdatePqrsRequestEntity(
        id: pqrsId,
        subject: 'Consulta actualizada',
        description: 'Información actualizada sobre servicios',
        status: 'en_proceso',
      );

      final now = DateTime.now();
      final expectedPqrs = PqrsEntity(
        id: pqrsId,
        subject: 'Consulta actualizada',
        description: 'Información actualizada sobre servicios',
        radicadorId: 'user123',
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
      );

      when(() => mockRepository.update(pqrsId, request))
          .thenAnswer((_) async => expectedPqrs);

      // Act
      final result = await useCase.call(pqrsId, request);

      // Assert
      expect(result, equals(expectedPqrs));
      verify(() => mockRepository.update(pqrsId, request)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const pqrsId = '999';
      final request = UpdatePqrsRequestEntity(
        id: pqrsId,
        subject: 'Consulta actualizada',
      );

      when(() => mockRepository.update(pqrsId, request))
          .thenThrow(Exception('PQRS no encontrado'));

      // Act & Assert
      expect(() => useCase.call(pqrsId, request), throwsException);
      verify(() => mockRepository.update(pqrsId, request)).called(1);
    });
  });
}
