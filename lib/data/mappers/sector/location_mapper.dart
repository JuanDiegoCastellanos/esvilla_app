import 'package:esvilla_app/data/models/sectors/location_model.dart';
import 'package:esvilla_app/domain/entities/sectors/location_entity.dart';

class LocationMapper {
  static LocationModel toModel(LocationEntity entity) => LocationModel(
    type: entity.type,
    coordinates: entity.coordinates 
  );

  static LocationEntity toEntity(LocationModel model) => LocationEntity(
    type: model.type,
    coordinates: model.coordinates
  );
}