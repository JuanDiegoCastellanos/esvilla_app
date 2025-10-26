import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/data/datasources/pqrs/pqrs_remote_data_source.dart';
import 'package:esvilla_app/data/mappers/pqrs/pqrs_mapper.dart';
import 'package:esvilla_app/data/models/pqrs/pqrs_create_request.dart';
import 'package:esvilla_app/data/models/pqrs/pqrs_model.dart';
import 'package:esvilla_app/data/models/pqrs/pqrs_update_request.dart';
import 'package:esvilla_app/data/repositories/pqrs/pqrs_repository_impl.dart';
import 'package:esvilla_app/domain/entities/pqrs/create_pqrs_request_entity.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/entities/pqrs/update_pqrs_request_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPqrsRemoteDataSource extends Mock implements PqrsRemoteDataSource {}

void main() {
  late PqrsRepositoryImpl repository;
  late MockPqrsRemoteDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(CreatePqrsRequest(
      subject: 'Test Subject',
      description: 'Test Description',
      status: 'pendiente',
    ));
    registerFallbackValue(UpdatePqrsRequest(
      id: 'test-id',
      subject: 'Updated Subject',
      description: 'Updated Description',
      status: 'pendiente',
    ));
  });

  setUp(() {
    mockDataSource = MockPqrsRemoteDataSource();
    repository = PqrsRepositoryImpl(mockDataSource);
  });

  group('PqrsRepositoryImpl', () {
    group('generatePqrs', () {
      test('debería generar un PQRS exitosamente', () async {
        // Arrange
        final requestEntity = CreatePqrsRequestEntity(
          subject: 'Consulta sobre servicios',
          description: 'Necesito información sobre los servicios disponibles',
          status: PqrsStatusEnum.pendiente.name,
        );

        final requestModel = CreatePqrsRequest(
          subject: 'Consulta sobre servicios',
          description: 'Necesito información sobre los servicios disponibles',
          status: PqrsStatusEnum.pendiente.name,
        );

        final now = DateTime.now();
        final responseModel = PqrsModel(
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
          resolucion: null,
          resolverName: null,
        );

        when(() => mockDataSource.generatePqrs(any()))
            .thenAnswer((_) async => responseModel);

        // Act
        final result = await repository.generatePqrs(requestEntity);

        // Assert
        expect(result.id, equals('1'));
        expect(result.subject, equals('Consulta sobre servicios'));
        verify(() => mockDataSource.generatePqrs(any())).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        final requestEntity = CreatePqrsRequestEntity(
          subject: 'Consulta sobre servicios',
          description: 'Necesito información sobre los servicios disponibles',
          status: PqrsStatusEnum.pendiente.name,
        );

        when(() => mockDataSource.generatePqrs(any()))
            .thenThrow(Exception('Error del servidor'));

        // Act & Assert
        expect(() => repository.generatePqrs(requestEntity),
            throwsA(isA<AppException>()));
        verify(() => mockDataSource.generatePqrs(any())).called(1);
      });
    });

    group('getAll', () {
      test('debería obtener todos los PQRS exitosamente', () async {
        // Arrange
        final now = DateTime.now();
        final pqrsModels = [
          PqrsModel(
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
            resolucion: null,
            resolverName: null,
          ),
          PqrsModel(
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
            resolucion: null,
            resolverName: null,
          ),
        ];

        when(() => mockDataSource.getPqrs())
            .thenAnswer((_) async => pqrsModels);

        // Act
        final result = await repository.getAll();

        // Assert
        expect(result.length, equals(2));
        expect(result[0].id, equals('1'));
        expect(result[1].id, equals('2'));
        verify(() => mockDataSource.getPqrs()).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        when(() => mockDataSource.getPqrs())
            .thenThrow(Exception('Error del servidor'));

        // Act & Assert
        expect(() => repository.getAll(), throwsA(isA<AppException>()));
        verify(() => mockDataSource.getPqrs()).called(1);
      });
    });

    group('getById', () {
      test('debería obtener un PQRS por ID exitosamente', () async {
        // Arrange
        const pqrsId = '1';
        final now = DateTime.now();
        final pqrsModel = PqrsModel(
          id: pqrsId,
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
          resolucion: null,
          resolverName: null,
        );

        when(() => mockDataSource.getPqrsById(pqrsId))
            .thenAnswer((_) async => pqrsModel);

        // Act
        final result = await repository.getById(pqrsId);

        // Assert
        expect(result.id, equals(pqrsId));
        expect(result.subject, equals('Consulta sobre servicios'));
        verify(() => mockDataSource.getPqrsById(pqrsId)).called(1);
      });

      test('debería lanzar excepción cuando el ID está vacío', () async {
        // Arrange
        const emptyId = '';

        // Act & Assert
        expect(() => repository.getById(emptyId), throwsA(isA<AppException>()));
        verifyNever(() => mockDataSource.getPqrsById(any()));
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        const pqrsId = '999';

        when(() => mockDataSource.getPqrsById(pqrsId))
            .thenThrow(Exception('PQRS no encontrado'));

        // Act & Assert
        expect(() => repository.getById(pqrsId), throwsA(isA<AppException>()));
        verify(() => mockDataSource.getPqrsById(pqrsId)).called(1);
      });
    });

    group('getMyPqrs', () {
      test('debería obtener mi PQRS exitosamente', () async {
        // Arrange
        final now = DateTime.now();
        final pqrsModel = PqrsModel(
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
          resolucion: null,
          resolverName: null,
        );

        when(() => mockDataSource.getMyPqrs())
            .thenAnswer((_) async => pqrsModel);

        // Act
        final result = await repository.getMyPqrs();

        // Assert
        expect(result, isNotNull);
        expect(result!.id, equals('1'));
        expect(result.subject, equals('Consulta sobre servicios'));
        verify(() => mockDataSource.getMyPqrs()).called(1);
      });

      test('debería retornar null cuando no hay PQRS', () async {
        // Arrange
        when(() => mockDataSource.getMyPqrs()).thenAnswer((_) async => null);

        // Act
        final result = await repository.getMyPqrs();

        // Assert
        expect(result, isNull);
        verify(() => mockDataSource.getMyPqrs()).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        when(() => mockDataSource.getMyPqrs())
            .thenThrow(Exception('Error del servidor'));

        // Act & Assert
        expect(() => repository.getMyPqrs(), throwsA(isA<AppException>()));
        verify(() => mockDataSource.getMyPqrs()).called(1);
      });
    });

    group('update', () {
      test('debería actualizar un PQRS exitosamente', () async {
        // Arrange
        const pqrsId = '1';
        final requestEntity = UpdatePqrsRequestEntity(
          id: pqrsId,
          subject: 'Consulta actualizada',
          description: 'Información actualizada sobre servicios',
          status: PqrsStatusEnum.EnProceso.name,
        );

        final requestModel = UpdatePqrsRequest(
          id: pqrsId,
          subject: 'Consulta actualizada',
          description: 'Información actualizada sobre servicios',
          status: PqrsStatusEnum.EnProceso.name,
        );

        final now = DateTime.now();
        final responseModel = PqrsModel(
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
          resolucion: null,
          resolverName: null,
        );

        when(() => mockDataSource.updatePqrs(any()))
            .thenAnswer((_) async => responseModel);

        // Act
        final result = await repository.update(pqrsId, requestEntity);

        // Assert
        expect(result.id, equals(pqrsId));
        expect(result.subject, equals('Consulta actualizada'));
        verify(() => mockDataSource.updatePqrs(any())).called(1);
      });

      test('debería lanzar excepción cuando el ID está vacío', () async {
        // Arrange
        const emptyId = '';
        final requestEntity = UpdatePqrsRequestEntity(
          id: emptyId,
          subject: 'Consulta actualizada',
        );

        // Act & Assert
        expect(() => repository.update(emptyId, requestEntity),
            throwsA(isA<AppException>()));
        verifyNever(() => mockDataSource.updatePqrs(any()));
      });

      test('debería lanzar excepción cuando el ID no coincide', () async {
        // Arrange
        const pqrsId = '1';
        const differentId = '2';
        final requestEntity = UpdatePqrsRequestEntity(
          id: differentId,
          subject: 'Consulta actualizada',
        );

        // Act & Assert
        expect(() => repository.update(pqrsId, requestEntity),
            throwsA(isA<AppException>()));
        verifyNever(() => mockDataSource.updatePqrs(any()));
      });
    });

    group('delete', () {
      test('debería eliminar un PQRS exitosamente', () async {
        // Arrange
        const pqrsId = '1';
        final now = DateTime.now();
        final pqrsModel = PqrsModel(
          id: pqrsId,
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
          resolucion: null,
          resolverName: null,
        );

        when(() => mockDataSource.deletePqrs(pqrsId))
            .thenAnswer((_) async => pqrsModel);

        // Act
        final result = await repository.delete(pqrsId);

        // Assert
        expect(result.id, equals(pqrsId));
        verify(() => mockDataSource.deletePqrs(pqrsId)).called(1);
      });

      test('debería lanzar excepción cuando el ID está vacío', () async {
        // Arrange
        const emptyId = '';

        // Act & Assert
        expect(() => repository.delete(emptyId), throwsA(isA<AppException>()));
        verifyNever(() => mockDataSource.deletePqrs(any()));
      });
    });

    group('getPqrsByUser', () {
      test('debería obtener PQRS por usuario exitosamente', () async {
        // Arrange
        const userId = 'user123';
        final now = DateTime.now();
        final pqrsModels = [
          PqrsModel(
            id: '1',
            subject: 'Consulta sobre servicios',
            description: 'Necesito información sobre los servicios disponibles',
            radicadorId: userId,
            radicadorName: 'Juan Pérez',
            radicadorPhone: '3001234567',
            radicadorEmail: 'juan@example.com',
            radicadorDocument: '12345678',
            status: PqrsStatusEnum.pendiente,
            createdAt: now,
            updatedAt: now,
            closureDate: null,
            resolucion: null,
            resolverName: null,
          ),
        ];

        when(() => mockDataSource.getPqrsByUser(userId))
            .thenAnswer((_) async => pqrsModels);

        // Act
        final result = await repository.getPqrsByUser(userId);

        // Assert
        expect(result.length, equals(1));
        expect(result[0].id, equals('1'));
        verify(() => mockDataSource.getPqrsByUser(userId)).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        const userId = 'user123';

        when(() => mockDataSource.getPqrsByUser(userId))
            .thenThrow(Exception('Error del servidor'));

        // Act & Assert
        expect(() => repository.getPqrsByUser(userId),
            throwsA(isA<AppException>()));
        verify(() => mockDataSource.getPqrsByUser(userId)).called(1);
      });
    });

    group('closePqrs', () {
      test('debería cerrar un PQRS exitosamente', () async {
        // Arrange
        final requestEntity = UpdatePqrsRequestEntity(
          id: '1',
          resolution: 'PQRS resuelto satisfactoriamente',
          resolverName: 'Admin',
          status: PqrsStatusEnum.solucionado.name,
        );

        final requestModel = UpdatePqrsRequest(
          id: '1',
          resolucion: 'PQRS resuelto satisfactoriamente',
          resolverName: 'Admin',
          status: PqrsStatusEnum.solucionado.name,
        );

        final now = DateTime.now();
        final responseModel = PqrsModel(
          id: '1',
          subject: 'Consulta sobre servicios',
          description: 'Necesito información sobre los servicios disponibles',
          radicadorId: 'user123',
          radicadorName: 'Juan Pérez',
          radicadorPhone: '3001234567',
          radicadorEmail: 'juan@example.com',
          radicadorDocument: '12345678',
          status: PqrsStatusEnum.solucionado,
          createdAt: now,
          updatedAt: now,
          closureDate: now,
          resolucion: 'PQRS resuelto satisfactoriamente',
          resolverName: 'Admin',
        );

        when(() => mockDataSource.closePqrs(any()))
            .thenAnswer((_) async => responseModel);

        // Act
        final result = await repository.closePqrs(requestEntity);

        // Assert
        expect(result.id, equals('1'));
        expect(result.status.name, equals('solucionado'));
        expect(result.resolution, equals('PQRS resuelto satisfactoriamente'));
        verify(() => mockDataSource.closePqrs(any())).called(1);
      });

      test('debería propagar excepciones del datasource', () async {
        // Arrange
        final requestEntity = UpdatePqrsRequestEntity(
          id: '1',
          resolution: 'PQRS resuelto satisfactoriamente',
        );

        when(() => mockDataSource.closePqrs(any()))
            .thenThrow(Exception('Error del servidor'));

        // Act & Assert
        expect(() => repository.closePqrs(requestEntity),
            throwsA(isA<AppException>()));
        verify(() => mockDataSource.closePqrs(any())).called(1);
      });
    });
  });
}
