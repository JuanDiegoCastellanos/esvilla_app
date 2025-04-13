import 'package:esvilla_app/domain/entities/schedules/add_sectors_request_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/create_schedule_request_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/update_schedule_request_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/update_sectors_schedule_request_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/repositories/generic_repository.dart';

abstract class SchedulesRepository implements GenericRepository<ScheduleEntity, CreateScheduleRequestEntity, UpdateScheduleRequestEntity> {
  Future<ScheduleEntity> getScheduleOfASector(String id);

  Future<List<SectorEntity>> getSectorsByScheduleId(String id);

  Future<ScheduleEntity> addSectorsToSchedule(String id, AddSectorsRequestEntity request);

  Future<ScheduleEntity> updateSectorsFromSchedule(String id, UpdateSectorsScheduleRequestEntity request);

}