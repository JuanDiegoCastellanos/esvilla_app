import 'package:esvilla_app/data/mappers/schedules/schedules_mapper.dart';
import 'package:esvilla_app/data/models/schedules/schedule_model.dart';
import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SchedulesMapper toEntity/toModel y listas', () {
    final now = DateTime.now();
    final model = ScheduleModel(
      id: 's1', days: const ['Lunes'], startTime: '08:00', endTime: '10:00',
      associatedSectors: const ['sec1'], active: true, observations: 'obs', garbageType: 'general',
      createdAt: now, updatedAt: now,
    );
    final e = SchedulesMapper.toEntity(model);
    expect(e.id, 's1');
    expect(e.days, contains('Lunes'));
    final back = SchedulesMapper.toModel(e);
    expect(back.startTime, '08:00');

    final listE = SchedulesMapper.toEntityList([model]);
    expect(listE.first.garbageType, 'general');
    final listM = SchedulesMapper.toModelList(listE);
    expect(listM.first.associatedSectors, contains('sec1'));
  });
}


