import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';
import 'package:esvilla_app/domain/use_cases/pqrs/get_my_pqrs_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPqrsRepository extends Mock implements PqrsRepository {}

void main() {
  late GetMyPqrsUseCase useCase;
  late MockPqrsRepository mockRepository;

  setUp(() {
    mockRepository = MockPqrsRepository();
    useCase = GetMyPqrsUseCase(mockRepository);
  });

  group('GetMyPqrsUseCase', () {
    test('debería obtener mi PQRS exitosamente', () async {
      // Arrange
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

      when(() => mockRepository.getMyPqrs())
          .thenAnswer((_) async => expectedPqrs);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(expectedPqrs));
      verify(() => mockRepository.getMyPqrs()).called(1);
    });

    test('debería retornar null cuando no hay PQRS', () async {
      // Arrange
      when(() => mockRepository.getMyPqrs())
          .thenAnswer((_) async => null);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isNull);
      verify(() => mockRepository.getMyPqrs()).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      when(() => mockRepository.getMyPqrs())
          .thenThrow(Exception('Error del servidor'));

      // Act & Assert
      expect(() => useCase.call(), throwsException);
      verify(() => mockRepository.getMyPqrs()).called(1);
    });
  });
}
