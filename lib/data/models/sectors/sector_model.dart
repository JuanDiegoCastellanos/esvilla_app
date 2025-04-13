import 'package:esvilla_app/data/models/sectors/location_model.dart';

class SectorModel {
    final LocationModel location;
    final String id;
    final String name;
    final String description;
    final DateTime updatedAt;

    SectorModel({
        required this.location,
        required this.id,
        required this.name,
        required this.description,
        required this.updatedAt,
    });
    factory SectorModel.fromMap(Map<String, dynamic> json) => SectorModel(
        location: LocationModel.fromMap(json["ubicacion"]),
        id: json["_id"],
        name: json["nombre"],
        description: json["descripcion"],
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "ubicacion": location.toJson(),
        "nombre": name,
        "descripcion": description,
        "updatedAt": updatedAt.toIso8601String(),
    };
}


