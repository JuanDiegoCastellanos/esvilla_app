import 'package:esvilla_app/domain/entities/sectors/location_entity.dart';

class UpdateSectorRequestEntity {
  final String id;
  final LocationEntity? location;
  final String? name;
  final String? description;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  const UpdateSectorRequestEntity({
    required this.id,
    this.location,
    this.name,
    this.description,
    this.updatedAt,
    this.createdAt,
  });
}
