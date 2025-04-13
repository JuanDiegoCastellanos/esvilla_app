import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';

class GetSectorsByScheduleUseCase {
  final SchedulesRepository _repository;

  GetSectorsByScheduleUseCase(this._repository);

  Future<List<SectorEntity>> call(String scheduleId) async =>
      await _repository.getSectorsByScheduleId(scheduleId);
}
