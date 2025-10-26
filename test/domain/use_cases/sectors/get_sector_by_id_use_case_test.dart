import 'package:esvilla_app/domain/entities/sectors/location_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/repositories/sectors_repository.dart';
import 'package:esvilla_app/domain/use_cases/sectors/get_sector_by_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSectorsRepository extends Mock implements SectorsRepository {}

void main() {
  late GetSectorByIdUseCase useCase;
  late MockSectorsRepository mockRepository;

  setUp(() {
    mockRepository = MockSectorsRepository();
    useCase = GetSectorByIdUseCase(mockRepository);
  });

  group('GetSectorByIdUseCase', () {
    test('debería obtener un sector por ID exitosamente', () async {
      // Arrange
      const sectorId = '1';
      final location = LocationEntity(
        type: 'Polygon',
        coordinates: [
          [
            [0.0, 0.0],
            [1.0, 0.0],
            [1.0, 1.0],
            [0.0, 1.0],
            [0.0, 0.0]
          ]
        ],
      );

      final now = DateTime.now();
      final expectedSector = SectorEntity(
        id: sectorId,
        name: 'Sector Norte',
        description: 'Sector ubicado en la zona norte',
        location: location,
        createdAt: now,
        updatedAt: now,
      );

      when(() => mockRepository.getById(sectorId))
          .thenAnswer((_) async => expectedSector);

      // Act
      final result = await useCase.call(sectorId);

      // Assert
      expect(result, equals(expectedSector));
      verify(() => mockRepository.getById(sectorId)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const sectorId = '999';

      when(() => mockRepository.getById(sectorId))
          .thenThrow(Exception('Sector no encontrado'));

      // Act & Assert
      expect(() => useCase.call(sectorId), throwsException);
      verify(() => mockRepository.getById(sectorId)).called(1);
    });
  });
}
