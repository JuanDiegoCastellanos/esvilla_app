import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/domain/entities/pqrs/create_pqrs_request_entity.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';
import 'package:esvilla_app/domain/use_cases/pqrs/generate_pqrs_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPqrsRepository extends Mock implements PqrsRepository {}

void main() {
  late GeneratePqrsUseCase useCase;
  late MockPqrsRepository mockRepository;

  setUp(() {
    mockRepository = MockPqrsRepository();
    useCase = GeneratePqrsUseCase(mockRepository);
  });

  group('GeneratePqrsUseCase', () {
    test('debería generar un PQRS exitosamente', () async {
      // Arrange
      final request = CreatePqrsRequestEntity(
        subject: 'Consulta sobre servicios',
        description: 'Necesito información sobre los servicios disponibles',
        status: 'pendiente',
      );

      final now = DateTime.now();
      final expectedPqrs = PqrsEntity(
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
      );

      when(() => mockRepository.generatePqrs(request))
          .thenAnswer((_) async => expectedPqrs);

      // Act
      final result = await useCase.call(request);

      // Assert
      expect(result, equals(expectedPqrs));
      verify(() => mockRepository.generatePqrs(request)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      final request = CreatePqrsRequestEntity(
        subject: 'Consulta sobre servicios',
        description: 'Necesito información sobre los servicios disponibles',
        status: 'pendiente',
      );

      when(() => mockRepository.generatePqrs(request))
          .thenThrow(Exception('Error al crear PQRS'));

      // Act & Assert
      expect(() => useCase.call(request), throwsException);
      verify(() => mockRepository.generatePqrs(request)).called(1);
    });
  });
}
