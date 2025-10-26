import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';
import 'package:esvilla_app/domain/use_cases/pqrs/get_all_pqrs_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPqrsRepository extends Mock implements PqrsRepository {}

void main() {
  late GetAllPqrsUseCase useCase;
  late MockPqrsRepository mockRepository;

  setUp(() {
    mockRepository = MockPqrsRepository();
    useCase = GetAllPqrsUseCase(mockRepository);
  });

  group('GetAllPqrsUseCase', () {
    test('debería obtener todos los PQRS exitosamente', () async {
      // Arrange
      final now = DateTime.now();
      final expectedPqrsList = [
        PqrsEntity(
          id: '1',
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
        ),
        PqrsEntity(
          id: '2',
          subject: 'Reclamo por servicio',
          description: 'El servicio no funcionó correctamente',
          radicadorId: 'user456',
          radicadorName: 'María García',
          radicadorPhone: '3007654321',
          radicadorEmail: 'maria@example.com',
          radicadorDocument: '87654321',
          status: PqrsStatusEnum.EnProceso,
          createdAt: now,
          updatedAt: now,
          closureDate: null,
          resolution: null,
          resolverName: null,
        ),
      ];

      when(() => mockRepository.getAll())
          .thenAnswer((_) async => expectedPqrsList);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(expectedPqrsList));
      expect(result.length, equals(2));
      verify(() => mockRepository.getAll()).called(1);
    });

    test('debería retornar lista vacía cuando no hay PQRS', () async {
      // Arrange
      when(() => mockRepository.getAll())
          .thenAnswer((_) async => <PqrsEntity>[]);

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
