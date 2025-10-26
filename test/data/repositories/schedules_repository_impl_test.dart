import 'package:esvilla_app/data/datasources/schedules/schedules_remote_data_source.dart';
import 'package:esvilla_app/data/models/schedules/schedule_model.dart';
import 'package:esvilla_app/data/repositories/schedules/schedules_repository_impl.dart';
import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSchedulesDs extends Mock implements SchedulesRemoteDataSource {}

void main() {
  late _MockSchedulesDs ds;
  late SchedulesRepositoryImpl repo;

  setUp(() {
    ds = _MockSchedulesDs();
    repo = SchedulesRepositoryImpl(ds);
  });

  test('getAll mapea ScheduleModel a ScheduleEntity', () async {
    final now = DateTime.now();
    final model = ScheduleModel(
      id: 's1',
      days: ['Lunes'],
      startTime: '08:00',
      endTime: '10:00',
      associatedSectors: const ['z1'],
      active: true,
      observations: 'obs',
      garbageType: 'organica',
      createdAt: now,
      updatedAt: now,
    );
    when(() => ds.getSchedules()).thenAnswer((_) async => [model]);

    final list = await repo.getAll();
    expect(list, isA<List<ScheduleEntity>>());
    expect(list.first.id, 's1');
    expect(list.first.days, contains('Lunes'));
  });
}
