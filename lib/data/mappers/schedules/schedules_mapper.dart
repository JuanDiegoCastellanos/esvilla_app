import 'package:esvilla_app/data/models/schedules/add_sectors_request.dart';
import 'package:esvilla_app/data/models/schedules/create_schedule_request.dart';
import 'package:esvilla_app/data/models/schedules/schedule_model.dart';
import 'package:esvilla_app/data/models/schedules/update_schedule_request.dart';
import 'package:esvilla_app/data/models/schedules/update_sectors_schedule_request.dart';
import 'package:esvilla_app/domain/entities/schedules/add_sectors_request_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/create_schedule_request_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/update_schedule_request_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/update_sectors_schedule_request_entity.dart';

class SchedulesMapper {
  static List<ScheduleEntity> toEntityList(List<ScheduleModel> models) =>
      models.map((model) => toEntity(model)).toList();

  static ScheduleModel toModel(ScheduleEntity entity) => ScheduleModel(
      id: entity.id,
      days: entity.days,
      startTime: entity.startTime,
      endTime: entity.endTime,
      associatedSectors: entity.associatedSectors,
      active: entity.active,
      observations: entity.observations,
      garbageType: entity.garbageType,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt);

  static ScheduleEntity toEntity(ScheduleModel model) => ScheduleEntity(
      id: model.id,
      days: model.days,
      startTime: model.startTime,
      endTime: model.endTime,
      associatedSectors: model.associatedSectors,
      active: model.active,
      observations: model.observations,
      garbageType: model.garbageType,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt
  );

  static List<ScheduleModel> toModelList(List<ScheduleEntity> entities) =>
      entities.map((entity) => toModel(entity)).toList();
  
  static CreateScheduleRequest toCreateRequest(CreateScheduleRequestEntity entity){
    return CreateScheduleRequest(
      days: entity.days,
      startTime: entity.startTime,
      endTime: entity.endTime,
      associatedSectors: entity.associatedSectors,
      active: entity.active,
      observations: entity.observations,
      garbageType: entity.garbageType,
    );
  }

  static UpdateScheduleRequest toUpdateRequest(UpdateScheduleRequestEntity entity){
    return UpdateScheduleRequest(
      id: entity.id,
      days: entity.days,
      startTime: entity.startTime,
      endTime: entity.endTime,
      associatedSectors: entity.associatedSectors,
      active: entity.active,
      observations: entity.observations,
      garbageType: entity.garbageType,
    );
  }

  static AddSectorsRequestEntity toAddSectorsRequestEntity(AddSectorsRequest entity){
    return AddSectorsRequestEntity(
      sectors: entity.sectors,
    );
  } 
  static AddSectorsRequest toAddSectorsRequest(AddSectorsRequestEntity entity){
    return AddSectorsRequest(
      sectors: entity.sectors,
    );
  } 
  static UpdateSectorsScheduleRequestEntity toUpdateRequestEntity(UpdateSectorsScheduleRequest request){
    return UpdateSectorsScheduleRequestEntity(
      sectors: request.sectors,
    );
  }
  static UpdateSectorsScheduleRequest toUpdateSectorsRequest(UpdateSectorsScheduleRequestEntity request){
    return UpdateSectorsScheduleRequest(
      sectors: request.sectors,
    );
  }
}
