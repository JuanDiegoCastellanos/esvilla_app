import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/update_sectors_schedule_request_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';

class UpdateSectorsOfScheduleUseCase {
  final SchedulesRepository _repository;

  UpdateSectorsOfScheduleUseCase(this._repository);

  Future<ScheduleEntity> call(String scheduleId, UpdateSectorsScheduleRequestEntity request) async => 
  await _repository.updateSectorsFromSchedule(scheduleId, request);
}