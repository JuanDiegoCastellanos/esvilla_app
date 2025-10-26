import 'package:esvilla_app/domain/entities/sectors/create_sector_request_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/location_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/repositories/sectors_repository.dart';
import 'package:esvilla_app/domain/use_cases/sectors/create_sector_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSectorsRepository extends Mock implements SectorsRepository {}

void main() {
  late CreateSectorUseCase useCase;
  late MockSectorsRepository mockRepository;

  setUp(() {
    mockRepository = MockSectorsRepository();
    useCase = CreateSectorUseCase(mockRepository);
  });

  group('CreateSectorUseCase', () {
    test('debería crear un sector exitosamente', () async {
      // Arrange
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

      final request = CreateSectorRequestEntity(
        name: 'Sector Norte',
        description: 'Sector ubicado en la zona norte',
        location: location,
      );

      final now = DateTime.now();
      final expectedSector = SectorEntity(
        id: '1',
        name: 'Sector Norte',
        description: 'Sector ubicado en la zona norte',
        location: location,
        createdAt: now,
        updatedAt: now,
      );

      when(() => mockRepository.add(request))
          .thenAnswer((_) async => expectedSector);

      // Act
      final result = await useCase.call(request);

      // Assert
      expect(result, equals(expectedSector));
      verify(() => mockRepository.add(request)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
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

      final request = CreateSectorRequestEntity(
        name: 'Sector Norte',
        description: 'Sector ubicado en la zona norte',
        location: location,
      );

      when(() => mockRepository.add(request))
          .thenThrow(Exception('Error al crear sector'));

      // Act & Assert
      expect(() => useCase.call(request), throwsException);
      verify(() => mockRepository.add(request)).called(1);
    });
  });
}
