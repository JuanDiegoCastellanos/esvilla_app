import 'package:esvilla_app/domain/entities/sectors/location_entity.dart';

class SectorEntity {
    final LocationEntity location;
    final String id;
    final String name;
    final String description;
    final DateTime updatedAt;
    final DateTime? createdAt;

    SectorEntity({
        required this.location,
        required this.id,
        required this.name,
        required this.description,
        required this.updatedAt,
        this.createdAt,
    });
}