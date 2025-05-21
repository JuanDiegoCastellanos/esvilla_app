import 'package:esvilla_app/domain/entities/sectors/create_sector_request_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/location_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/update_sector_request_entity.dart';

class SectorModelPresentation {
  final LocationModelPresentation? location;
  final String? id;
  final String? name;
  final String? description;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  SectorModelPresentation({
    this.location,
    this.id,
    this.name,
    this.description,
    this.updatedAt,
    this.createdAt,
  });

  static SectorEntity toSectorEntity(SectorModelPresentation presentation) {
    return SectorEntity(
      id: presentation.id ?? '',
      name: presentation.name ?? '',
      description: presentation.description ?? '',
      location: LocationModelPresentation.toEntity(
          presentation.location ?? LocationModelPresentation()),
      createdAt: presentation.createdAt ?? DateTime.now(),
      updatedAt: presentation.updatedAt ?? DateTime.now(),
    );
  }

  static SectorModelPresentation fromEntity(SectorEntity entity) {
    return SectorModelPresentation(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      location: LocationModelPresentation.fromEntity(entity.location),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static UpdateSectorRequestEntity toUpdateSectorRequestEntity(
      SectorModelPresentation presentation) {
    return UpdateSectorRequestEntity(
      id: presentation.id ?? '',
      name: presentation.name ?? '',
      description: presentation.description ?? '',
      location: LocationModelPresentation.toEntity(
          presentation.location ?? LocationModelPresentation()),    
      updatedAt: presentation.updatedAt ?? DateTime.now(),
    );
  }

  static CreateSectorRequestEntity toCreateSectorRequestEntity(
      SectorModelPresentation presentation) {
    return CreateSectorRequestEntity(
      name: presentation.name ?? '',
      description: presentation.description ?? '',
      location: LocationModelPresentation.toEntity(
          presentation.location ?? LocationModelPresentation()),
    );
  }

  
  static List<SectorModelPresentation> fromEntityList(
      List<SectorEntity> list) {
    return list.map((e) => fromEntity(e)).toList();
  }

  static List<SectorEntity> toEntityList(
      List<SectorModelPresentation> list) {
    return list.map((e) => toSectorEntity(e)).toList();
  }
}

class LocationModelPresentation {
  final String? type;
  final List<List<List<double>>>? coordinates;

  LocationModelPresentation({
    this.type,
    this.coordinates,
  });

  static LocationModelPresentation fromEntity(LocationEntity entity) {
    return LocationModelPresentation(
      type: entity.type,
      coordinates: entity.coordinates,
    );
  }

  static LocationEntity toEntity(LocationModelPresentation presentation) {
    return LocationEntity(
      type: presentation.type ?? '',
      coordinates: presentation.coordinates ?? [],
    );
  }
}
