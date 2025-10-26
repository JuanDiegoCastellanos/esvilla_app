import 'package:esvilla_app/domain/entities/sectors/location_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/repositories/sectors_repository.dart';
import 'package:esvilla_app/domain/use_cases/sectors/get_all_sectors_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSectorsRepository extends Mock implements SectorsRepository {}

void main() {
  late GetAllSectorsUseCase useCase;
  late MockSectorsRepository mockRepository;

  setUp(() {
    mockRepository = MockSectorsRepository();
    useCase = GetAllSectorsUseCase(mockRepository);
  });

  group('GetAllSectorsUseCase', () {
    test('debería obtener todos los sectores exitosamente', () async {
      // Arrange
      final now = DateTime.now();
      final location1 = LocationEntity(
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

      final location2 = LocationEntity(
        type: 'Polygon',
        coordinates: [
          [
            [2.0, 2.0],
            [3.0, 2.0],
            [3.0, 3.0],
            [2.0, 3.0],
            [2.0, 2.0]
          ]
        ],
      );

      final expectedSectors = [
        SectorEntity(
          id: '1',
          name: 'Sector Norte',
          description: 'Sector ubicado en la zona norte',
          location: location1,
          createdAt: now,
          updatedAt: now,
        ),
        SectorEntity(
          id: '2',
          name: 'Sector Sur',
          description: 'Sector ubicado en la zona sur',
          location: location2,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      when(() => mockRepository.getAll())
          .thenAnswer((_) async => expectedSectors);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(expectedSectors));
      expect(result.length, equals(2));
      verify(() => mockRepository.getAll()).called(1);
    });

    test('debería retornar lista vacía cuando no hay sectores', () async {
      // Arrange
      when(() => mockRepository.getAll())
          .thenAnswer((_) async => <SectorEntity>[]);

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
