import 'package:esvilla_app/domain/entities/sectors/location_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/repositories/sectors_repository.dart';
import 'package:esvilla_app/domain/use_cases/sectors/delete_sector_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSectorsRepository extends Mock implements SectorsRepository {}

void main() {
  late DeleteSectorUseCase useCase;
  late MockSectorsRepository mockRepository;

  setUp(() {
    mockRepository = MockSectorsRepository();
    useCase = DeleteSectorUseCase(mockRepository);
  });

  group('DeleteSectorUseCase', () {
    test('debería eliminar un sector exitosamente', () async {
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

      when(() => mockRepository.delete(sectorId))
          .thenAnswer((_) async => expectedSector);

      // Act
      final result = await useCase.call(sectorId);

      // Assert
      expect(result, equals(expectedSector));
      verify(() => mockRepository.delete(sectorId)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const sectorId = '999';

      when(() => mockRepository.delete(sectorId))
          .thenThrow(Exception('Sector no encontrado'));

      // Act & Assert
      expect(() => useCase.call(sectorId), throwsException);
      verify(() => mockRepository.delete(sectorId)).called(1);
    });
  });
}
