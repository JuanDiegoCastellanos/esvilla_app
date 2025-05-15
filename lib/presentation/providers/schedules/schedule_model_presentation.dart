import 'package:esvilla_app/domain/entities/schedules/create_schedule_request_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/update_schedule_request_entity.dart';

class ScheduleModelPresentation {
  final String? id;
  final List<String>? days;
  final String? startTime;
  final String? endTime;
  final List<String>? associatedSectors;
  final bool? active;
  final String? observations;
  final String? garbageType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ScheduleModelPresentation({
    this.id,
    this.days,
    this.startTime,
    this.endTime,
    this.associatedSectors,
    this.active,
    this.observations,
    this.garbageType,
    this.createdAt,
    this.updatedAt,
  });

  ScheduleEntity toEntity() => ScheduleEntity(
        id: id ?? '',
        days: days ?? [],
        startTime: startTime ?? '',
        endTime: endTime ?? '',
        associatedSectors: associatedSectors ?? [],
        active: active ?? false,
        observations: observations ?? '',
        garbageType: garbageType ?? '',
        createdAt: createdAt ?? DateTime.now(),
        updatedAt: updatedAt ?? DateTime.now(),
      );

  static ScheduleModelPresentation fromEntity(ScheduleEntity entity) => ScheduleModelPresentation(
        id: entity.id,
        days: entity.days,
        startTime: entity.startTime,
        endTime: entity.endTime,
        associatedSectors: entity.associatedSectors,
        active: entity.active,
        observations: entity.observations,
        garbageType: entity.garbageType,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  CreateScheduleRequestEntity toCreateEntity() => CreateScheduleRequestEntity(
        days: days??[],
        startTime: startTime ?? '',
        endTime: endTime ?? '',
        associatedSectors: associatedSectors ?? [],
        active: active ?? false,
        observations: observations ?? '',
        garbageType: garbageType ?? '',
      );

  UpdateScheduleRequestEntity toUpdateEntity() => UpdateScheduleRequestEntity(
        id: id!,
        days: days,
        startTime: startTime,
        endTime: endTime,
        associatedSectors: associatedSectors,
        active: active,
        observations: observations,
        garbageType: garbageType,
      );

  static List<ScheduleModelPresentation> fromEntityList(List<ScheduleEntity> entities) =>
      entities.map((e) => fromEntity(e)).toList();
      
}
