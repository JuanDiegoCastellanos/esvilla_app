import 'package:esvilla_app/domain/entities/schedules/create_schedule_request_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';

class CreateScheduleUseCase {
  final SchedulesRepository _repository;

  CreateScheduleUseCase(this._repository);

  Future<ScheduleEntity> call(CreateScheduleRequestEntity request) async =>
      await _repository.add(request);
}
