import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';
import 'package:esvilla_app/domain/use_cases/schedules/delete_schedule_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSchedulesRepository extends Mock implements SchedulesRepository {}

void main() {
  late DeleteScheduleUseCase useCase;
  late MockSchedulesRepository mockRepository;

  setUp(() {
    mockRepository = MockSchedulesRepository();
    useCase = DeleteScheduleUseCase(mockRepository);
  });

  group('DeleteScheduleUseCase', () {
    test('debería eliminar un horario exitosamente', () async {
      // Arrange
      const scheduleId = '1';
      final now = DateTime.now();
      final expectedSchedule = ScheduleEntity(
        id: scheduleId,
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

      when(() => mockRepository.delete(scheduleId))
          .thenAnswer((_) async => expectedSchedule);

      // Act
      final result = await useCase.call(scheduleId);

      // Assert
      expect(result, equals(expectedSchedule));
      verify(() => mockRepository.delete(scheduleId)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const scheduleId = '999';

      when(() => mockRepository.delete(scheduleId))
          .thenThrow(Exception('Horario no encontrado'));

      // Act & Assert
      expect(() => useCase.call(scheduleId), throwsException);
      verify(() => mockRepository.delete(scheduleId)).called(1);
    });
  });
}
