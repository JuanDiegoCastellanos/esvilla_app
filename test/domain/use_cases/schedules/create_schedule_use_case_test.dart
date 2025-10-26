import 'package:esvilla_app/domain/entities/schedules/create_schedule_request_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';
import 'package:esvilla_app/domain/use_cases/schedules/create_schedule_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSchedulesRepository extends Mock implements SchedulesRepository {}

void main() {
  late CreateScheduleUseCase useCase;
  late MockSchedulesRepository mockRepository;

  setUp(() {
    mockRepository = MockSchedulesRepository();
    useCase = CreateScheduleUseCase(mockRepository);
  });

  group('CreateScheduleUseCase', () {
    test('debería crear un horario exitosamente', () async {
      // Arrange
      final request = CreateScheduleRequestEntity(
        days: ['Lunes', 'Miércoles', 'Viernes'],
        startTime: '08:00',
        endTime: '12:00',
        associatedSectors: ['sector1', 'sector2'],
        active: true,
        observations: 'Recolección de basura orgánica',
        garbageType: 'orgánica',
      );

      final now = DateTime.now();
      final expectedSchedule = ScheduleEntity(
        id: '1',
        days: ['Lunes', 'Miércoles', 'Viernes'],
        startTime: '08:00',
        endTime: '12:00',
        associatedSectors: ['sector1', 'sector2'],
        active: true,
        observations: 'Recolección de basura orgánica',
        garbageType: 'orgánica',
        createdAt: now,
        updatedAt: now,
      );

      when(() => mockRepository.add(request))
          .thenAnswer((_) async => expectedSchedule);

      // Act
      final result = await useCase.call(request);

      // Assert
      expect(result, equals(expectedSchedule));
      verify(() => mockRepository.add(request)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      final request = CreateScheduleRequestEntity(
        days: ['Lunes', 'Miércoles', 'Viernes'],
        startTime: '08:00',
        endTime: '12:00',
        associatedSectors: ['sector1', 'sector2'],
        active: true,
        observations: 'Recolección de basura orgánica',
        garbageType: 'orgánica',
      );

      when(() => mockRepository.add(request))
          .thenThrow(Exception('Error al crear horario'));

      // Act & Assert
      expect(() => useCase.call(request), throwsException);
      verify(() => mockRepository.add(request)).called(1);
    });
  });
}
