import 'package:esvilla_app/data/mappers/sector/location_mapper.dart';
import 'package:esvilla_app/data/models/sectors/create_sectors_request.dart';
import 'package:esvilla_app/data/models/sectors/sector_model.dart';
import 'package:esvilla_app/data/models/sectors/update_sectors_request.dart';
import 'package:esvilla_app/domain/entities/sectors/create_sector_request_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/update_sector_request_entity.dart';

class SectorMapper {
  static SectorModel toModel(SectorEntity entity) {
    return SectorModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        location: LocationMapper.toModel(entity.location),
        updatedAt: entity.updatedAt);
  }

  static SectorEntity toEntity(SectorModel model) {
    return SectorEntity(
        id: model.id,
        name: model.name,
        description: model.description,
        location: LocationMapper.toEntity(model.location),
        updatedAt: model.updatedAt);
  }

  static CreateSectorRequest toRequest(CreateSectorRequestEntity entity) {
    return CreateSectorRequest(
        name: entity.name,
        description: entity.description,
        location: LocationMapper.toModel(entity.location));
  }

  static CreateSectorRequestEntity toRequestEntity(CreateSectorRequest request) {
    return CreateSectorRequestEntity(
        name: request.name,
        description: request.description,
        location: LocationMapper.toEntity(request.location));
  }

  static UpdateSectorsRequest toUpdateRequest(UpdateSectorRequestEntity entity) {
    return UpdateSectorsRequest(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        location: LocationMapper.toModel(entity.location!),
        updatedAt: entity.updatedAt);
  } 


  static List<SectorEntity> toEntityList(List<SectorModel> list) {
    return list.map((e) => toEntity(e)).toList();
  }

  static List<SectorModel> toModelList(List<SectorEntity> list) {
    return list.map((e) => toModel(e)).toList();
  }
}
