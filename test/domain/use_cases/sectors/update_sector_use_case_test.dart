import 'package:esvilla_app/domain/entities/sectors/location_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/update_sector_request_entity.dart';
import 'package:esvilla_app/domain/repositories/sectors_repository.dart';
import 'package:esvilla_app/domain/use_cases/sectors/update_sector_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSectorsRepository extends Mock implements SectorsRepository {}

void main() {
  late UpdateSectorUseCase useCase;
  late MockSectorsRepository mockRepository;

  setUp(() {
    mockRepository = MockSectorsRepository();
    useCase = UpdateSectorUseCase(mockRepository);
  });

  group('UpdateSectorUseCase', () {
    test('debería actualizar un sector exitosamente', () async {
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

      final request = UpdateSectorRequestEntity(
        id: sectorId,
        name: 'Sector Norte Actualizado',
        description: 'Sector actualizado en la zona norte',
        location: location,
      );

      final now = DateTime.now();
      final expectedSector = SectorEntity(
        id: sectorId,
        name: 'Sector Norte Actualizado',
        description: 'Sector actualizado en la zona norte',
        location: location,
        createdAt: now,
        updatedAt: now,
      );

      when(() => mockRepository.update(sectorId, request))
          .thenAnswer((_) async => expectedSector);

      // Act
      final result = await useCase.call(sectorId, request);

      // Assert
      expect(result, equals(expectedSector));
      verify(() => mockRepository.update(sectorId, request)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const sectorId = '999';
      final request = UpdateSectorRequestEntity(
        id: sectorId,
        name: 'Sector Actualizado',
      );

      when(() => mockRepository.update(sectorId, request))
          .thenThrow(Exception('Sector no encontrado'));

      // Act & Assert
      expect(() => useCase.call(sectorId, request), throwsException);
      verify(() => mockRepository.update(sectorId, request)).called(1);
    });
  });
}
