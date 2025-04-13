import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/update_schedule_request_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';

class UpdateScheduleUseCase {
  final SchedulesRepository _repository;

  UpdateScheduleUseCase(this._repository);

  Future<ScheduleEntity> call(String id, UpdateScheduleRequestEntity request) async => 
  await _repository.update(id, request);
  
}