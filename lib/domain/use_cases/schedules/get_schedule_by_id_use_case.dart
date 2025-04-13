import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';

class GetScheduleByIdUseCase {
  final SchedulesRepository _repository;

  GetScheduleByIdUseCase(this._repository);

  Future<ScheduleEntity> call(String id) async => await _repository.getById(id);
}
