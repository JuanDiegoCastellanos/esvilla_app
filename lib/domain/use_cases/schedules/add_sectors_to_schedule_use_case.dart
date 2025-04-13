import 'package:esvilla_app/domain/entities/schedules/add_sectors_request_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';

class AddSectorsToScheduleUseCase {
  final SchedulesRepository _repository;

  AddSectorsToScheduleUseCase(this._repository);

  Future call(String id, AddSectorsRequestEntity request) async{
    return await _repository.addSectorsToSchedule(id, request);
  }
}