import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';
import 'package:esvilla_app/domain/use_cases/schedules/get_schedule_by_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSchedulesRepository extends Mock implements SchedulesRepository {}

void main() {
  late GetScheduleByIdUseCase useCase;
  late MockSchedulesRepository mockRepository;

  setUp(() {
    mockRepository = MockSchedulesRepository();
    useCase = GetScheduleByIdUseCase(mockRepository);
  });

  group('GetScheduleByIdUseCase', () {
    test('debería obtener un horario por ID exitosamente', () async {
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

      when(() => mockRepository.getById(scheduleId))
          .thenAnswer((_) async => expectedSchedule);

      // Act
      final result = await useCase.call(scheduleId);

      // Assert
      expect(result, equals(expectedSchedule));
      verify(() => mockRepository.getById(scheduleId)).called(1);
    });

    test('debería propagar excepciones del repositorio', () async {
      // Arrange
      const scheduleId = '999';

      when(() => mockRepository.getById(scheduleId))
          .thenThrow(Exception('Horario no encontrado'));

      // Act & Assert
      expect(() => useCase.call(scheduleId), throwsException);
      verify(() => mockRepository.getById(scheduleId)).called(1);
    });
  });
}
