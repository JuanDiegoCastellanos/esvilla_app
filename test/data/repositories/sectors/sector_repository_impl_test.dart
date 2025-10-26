import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/datasources/sectors/sectors_remote_data_source.dart';
import 'package:esvilla_app/data/mappers/sector/sector_mapper.dart';
import 'package:esvilla_app/data/models/sectors/create_sectors_request.dart';
import 'package:esvilla_app/data/models/sectors/location_model.dart';
import 'package:esvilla_app/data/models/sectors/sector_model.dart';
import 'package:esvilla_app/data/models/sectors/update_sectors_request.dart';
import 'package:esvilla_app/data/repositories/sectors/sector_repository_impl.dart';
import 'package:esvilla_app/domain/entities/sectors/create_sector_request_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/location_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/update_sector_request_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSectorsRemoteDataSource extends Mock
    implements SectorsRemoteDataSource {}

void main() {
  late SectorRepositoryImpl repository;
  late MockSectorsRemoteDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(CreateSectorRequest(
      name: 'Test Sector',
      description: 'Test Description',
      location: LocationModel(
        type: 'Polygon',
        coordinates: [
          [
            [0.0, 0.0],
            [1.0, 0.0],
            [1.0, 1.0],
            [0.0, 1.0],
            [0.0, 0.0]
          ]
        ]
      ),
    ));
    registerFallbackValue(UpdateSectorsRequest(
      id: 'test-id',
      name: 'Updated Sector',
      description: 'Updated Description',
    ));
  });

  setUp(() {
    mockDataSource = MockSectorsRemoteDataSource();
    repository = SectorRepositoryImpl(mockDataSource);
  });

  group('SectorRepositoryImpl', () {
    group('add', () {
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

        final requestEntity = CreateSectorRequestEntity(
          name: 'Sector Norte',
          description: 'Sector ubicado en la zona norte',
          location: location,
        );

        final requestModel = CreateSectorRequest(
          name: 'Sector Norte',
          description: 'Sector ubicado en la zona norte',
          location: LocationModel(
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
          ),
        );

        final now = DateTime.now();
        final responseModel = SectorModel(
          id: '1',
          name: 'Sector Norte',
          description: 'Sector ubicado en la zona norte',
          location: LocationModel(
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
          ),
          createdAt: now,
          updatedAt: now,
        );

        when(() => mockDataSource.createSector(any()))
            .thenAnswer((_) async => responseModel);

        // Act
        final result = await repository.add(requestEntity);

        // Assert
        expect(result.id, equals('1'));
        expect(result.name, equals('Sector Norte'));
        verify(() => mockDataSource.createSector(any())).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
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

        final requestEntity = CreateSectorRequestEntity(
          name: 'Sector Norte',
          description: 'Sector ubicado en la zona norte',
          location: location,
        );

        when(() => mockDataSource.createSector(any()))
            .thenThrow(Exception('Error del servidor'));

        // Act & Assert
        expect(
            () => repository.add(requestEntity), throwsA(isA<AppException>()));
        verify(() => mockDataSource.createSector(any())).called(1);
      });
    });

    group('getAll', () {
      test('debería obtener todos los sectores exitosamente', () async {
        // Arrange
        final now = DateTime.now();
        final sectorModels = [
          SectorModel(
            id: '1',
            name: 'Sector Norte',
            description: 'Sector ubicado en la zona norte',
            location: LocationModel(
              type: 'Polygon',
              coordinates: [
                [
                  [0.0, 0.0],
                  [1.0, 0.0],
                  [1.0, 1.0],
                  [0.0, 1.0],
                  [0.0, 0.0]
                ]
              ]
            ),
            createdAt: now,
            updatedAt: now,
          ),
          SectorModel(
            id: '2',
            name: 'Sector Sur',
            description: 'Sector ubicado en la zona sur',
            location: LocationModel(
              type: 'Polygon',
              coordinates: [
                [
                  [2.0, 2.0],
                  [3.0, 2.0],
                  [3.0, 3.0],
                  [2.0, 3.0],
                  [2.0, 2.0]
                ]
              ]
            ),
            createdAt: now,
            updatedAt: now,
          ),
        ];

        when(() => mockDataSource.getSectors())
            .thenAnswer((_) async => sectorModels);

        // Act
        final result = await repository.getAll();

        // Assert
        expect(result.length, equals(2));
        expect(result[0].id, equals('1'));
        expect(result[1].id, equals('2'));
        verify(() => mockDataSource.getSectors()).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        when(() => mockDataSource.getSectors())
            .thenThrow(Exception('Error del servidor'));

        // Act & Assert
        expect(() => repository.getAll(), throwsA(isA<AppException>()));
        verify(() => mockDataSource.getSectors()).called(1);
      });
    });

    group('getById', () {
      test('debería obtener un sector por ID exitosamente', () async {
        // Arrange
        const sectorId = '1';
        final now = DateTime.now();
        final sectorModel = SectorModel(
          id: sectorId,
          name: 'Sector Norte',
          description: 'Sector ubicado en la zona norte',
          location: LocationModel(
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
          ),
          createdAt: now,
          updatedAt: now,
        );

        when(() => mockDataSource.getSectorById(sectorId))
            .thenAnswer((_) async => sectorModel);

        // Act
        final result = await repository.getById(sectorId);

        // Assert
        expect(result.id, equals(sectorId));
        expect(result.name, equals('Sector Norte'));
        verify(() => mockDataSource.getSectorById(sectorId)).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        const sectorId = '999';

        when(() => mockDataSource.getSectorById(sectorId))
            .thenThrow(Exception('Sector no encontrado'));

        // Act & Assert
        expect(
            () => repository.getById(sectorId), throwsA(isA<AppException>()));
        verify(() => mockDataSource.getSectorById(sectorId)).called(1);
      });
    });

    group('update', () {
      test('debería actualizar un sector exitosamente', () async {
        // Arrange
        const sectorId = '1';
        final requestEntity = UpdateSectorRequestEntity(
          id: sectorId,
          name: 'Sector Norte Actualizado',
          description: 'Sector actualizado en la zona norte',
          location: LocationEntity(
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
          ),
        );

        final requestModel = UpdateSectorsRequest(
          id: sectorId,
          name: 'Sector Norte Actualizado',
          description: 'Sector actualizado en la zona norte',
        );

        final now = DateTime.now();
        final responseModel = SectorModel(
          id: sectorId,
          name: 'Sector Norte Actualizado',
          description: 'Sector actualizado en la zona norte',
          location: LocationModel(
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
          ),
          createdAt: now,
          updatedAt: now,
        );

        when(() => mockDataSource.updateSector(any()))
            .thenAnswer((_) async => responseModel);

        // Act
        final result = await repository.update(sectorId, requestEntity);

        // Assert
        expect(result.id, equals(sectorId));
        expect(result.name, equals('Sector Norte Actualizado'));
        verify(() => mockDataSource.updateSector(any())).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        const sectorId = '999';
        final requestEntity = UpdateSectorRequestEntity(
          id: sectorId,
          name: 'Sector Actualizado',
          location: LocationEntity(
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
          ),
        );

        when(() => mockDataSource.updateSector(any()))
            .thenThrow(Exception('Sector no encontrado'));

        // Act & Assert
        expect(() => repository.update(sectorId, requestEntity),
            throwsA(isA<AppException>()));
        verify(() => mockDataSource.updateSector(any())).called(1);
      });
    });

    group('delete', () {
      test('debería eliminar un sector exitosamente', () async {
        // Arrange
        const sectorId = '1';
        final now = DateTime.now();
        final sectorModel = SectorModel(
          id: sectorId,
          name: 'Sector Norte',
          description: 'Sector ubicado en la zona norte',
          location: LocationModel(
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
          ),
          createdAt: now,
          updatedAt: now,
        );

        when(() => mockDataSource.deleteSector(sectorId))
            .thenAnswer((_) async => sectorModel);

        // Act
        final result = await repository.delete(sectorId);

        // Assert
        expect(result.id, equals(sectorId));
        verify(() => mockDataSource.deleteSector(sectorId)).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        const sectorId = '999';

        when(() => mockDataSource.deleteSector(sectorId))
            .thenThrow(Exception('Sector no encontrado'));

        // Act & Assert
        expect(() => repository.delete(sectorId), throwsA(isA<AppException>()));
        verify(() => mockDataSource.deleteSector(sectorId)).called(1);
      });
    });
  });
}
