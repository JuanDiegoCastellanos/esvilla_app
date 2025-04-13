import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';

class GetScheduleOfSectorUseCase {
  final SchedulesRepository _repository;

  GetScheduleOfSectorUseCase(this._repository);

  Future<ScheduleEntity> call(String sectorId) async => 
  await _repository.getScheduleOfASector(sectorId);
}