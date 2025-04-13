import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/update_sector_request_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';

class UpdateSectorsOfScheduleUseCase {
  final SchedulesRepository _repository;

  UpdateSectorsOfScheduleUseCase(this._repository);

  Future<ScheduleEntity> call(String scheduleId, UpdateSectorRequestEntity request) async => 
  await _repository.updateSectorsFromSchedule(scheduleId, request);
}