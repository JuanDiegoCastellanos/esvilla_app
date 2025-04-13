import 'package:esvilla_app/domain/entities/sectors/location_entity.dart';

class CreateSectorRequestEntity { 
    final String name;
    final String description;
    final LocationEntity location;

    CreateSectorRequestEntity({
        required this.name,
        required this.description,
        required this.location,
    });

}