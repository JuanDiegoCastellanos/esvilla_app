import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/update_schedule_request_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';
import 'package:esvilla_app/domain/use_cases/schedules/update_schedule_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSchedulesRepository extends Mock implements SchedulesRepository {}

void main() {
  late UpdateScheduleUseCase useCase;
  late MockSchedulesRepository mockRepository;

  setUp(() {
    mockRepository = MockSchedulesRepository();
    useCase = UpdateScheduleUseCase(mockRepository);
  });

  group('UpdateScheduleUseCase', () {
    test('debería actualizar un horario exitosamente', () async {
      // Arrange
      const scheduleId = '1';
      final request = UpdateScheduleRequestEntity(
        id: scheduleId,
        days: ['Lunes', 'Miércoles', 'Viernes', 'Domingo'],
        startTime: '09:00',
        endTime: '13:00',
        observations: 'Recolección de basura orgánica actualizada',
      );

      final now = DateTime.now();
      final expectedSchedule = ScheduleEntity(
        id: scheduleId,
        days: ['Lunes', 'Miércoles', 'Viernes', 'Domingo'],
        startTime: '09:00',
        endTime: '13:00',
        associatedSectors: ['sector1', 'sector2'],
        active: true,
        observations: 'Recolección de basura orgánica actualizada',
        garbageType: 'orgánica',
        createdAt: now,
        updatedAt: now,
      );

      when(() => mockRepository.update(scheduleId, request))
          .thenAnswer((_) async => expectedSchedule);

      // Act
      final result = await useCase.call(scheduleId, request);

      // Assert
      expect(result, equals(expectedSchedule));
      verify(() => mockRepository.update(scheduleId, request)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const scheduleId = '999';
      final request = UpdateScheduleRequestEntity(
        id: scheduleId,
        startTime: '09:00',
        endTime: '13:00',
      );

      when(() => mockRepository.update(scheduleId, request))
          .thenThrow(Exception('Horario no encontrado'));

      // Act & Assert
      expect(() => useCase.call(scheduleId, request), throwsException);
      verify(() => mockRepository.update(scheduleId, request)).called(1);
    });
  });
}
