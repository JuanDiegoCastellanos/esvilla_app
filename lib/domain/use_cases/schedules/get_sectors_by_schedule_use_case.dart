import 'package:esvilla_app/domain/repositories/schedules_repository.dart';

class GetSectorsByScheduleUseCase {
  final SchedulesRepository _repository;

  GetSectorsByScheduleUseCase(this._repository);

  Future<List<String>> call(String scheduleId) async =>
      await _repository.getSectorsByScheduleId(scheduleId);
}
