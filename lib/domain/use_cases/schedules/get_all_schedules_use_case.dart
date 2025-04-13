import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';

class GetAllSchedulesUseCase {

  final SchedulesRepository _repository;

  GetAllSchedulesUseCase(this._repository);
  
  Future<List<ScheduleEntity>> call() async => await _repository.getAll();

}