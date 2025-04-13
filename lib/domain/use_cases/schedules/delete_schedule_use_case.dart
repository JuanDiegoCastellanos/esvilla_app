import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';

class DeleteScheduleUseCase {
  final SchedulesRepository  _schedulesRepository;

  DeleteScheduleUseCase(this._schedulesRepository);

  Future<ScheduleEntity> call(String id) async => await _schedulesRepository.delete(id);
}