import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';
import 'package:esvilla_app/domain/use_cases/schedules/get_all_schedules_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSchedulesRepository extends Mock implements SchedulesRepository {}

void main() {
  late GetAllSchedulesUseCase useCase;
  late MockSchedulesRepository mockRepository;

  setUp(() {
    mockRepository = MockSchedulesRepository();
    useCase = GetAllSchedulesUseCase(mockRepository);
  });

  group('GetAllSchedulesUseCase', () {
    test('debería obtener todos los horarios exitosamente', () async {
      // Arrange
      final now = DateTime.now();
      final expectedSchedules = [
        ScheduleEntity(
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
        ),
        ScheduleEntity(
          id: '2',
          days: ['Martes', 'Jueves', 'Sábado'],
          startTime: '14:00',
          endTime: '18:00',
          associatedSectors: ['sector3', 'sector4'],
          active: true,
          observations: 'Recolección de basura reciclable',
          garbageType: 'reciclable',
          createdAt: now,
          updatedAt: now,
        ),
      ];

      when(() => mockRepository.getAll())
          .thenAnswer((_) async => expectedSchedules);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, equals(expectedSchedules));
      expect(result.length, equals(2));
      verify(() => mockRepository.getAll()).called(1);
    });

    test('debería retornar lista vacía cuando no hay horarios', () async {
      // Arrange
      when(() => mockRepository.getAll())
          .thenAnswer((_) async => <ScheduleEntity>[]);

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
