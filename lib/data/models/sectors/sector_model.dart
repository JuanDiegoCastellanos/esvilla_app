import 'package:esvilla_app/data/models/sectors/location_model.dart';

class SectorModel {
    final LocationModel location;
    final String id;
    final String name;
    final String description;
    final DateTime updatedAt;
    final DateTime createdAt;

    SectorModel({
        required this.location,
        required this.id,
        required this.name,
        required this.description,
        required this.updatedAt,
        required this.createdAt
    });
    factory SectorModel.fromMap(Map<String, dynamic> json) => SectorModel(
        location: LocationModel.fromMap(json["ubicacion"]),
        id: json["_id"],
        name: json["nombre"],
        description: json["descripcion"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "ubicacion": location.toJson(),
        "nombre": name,
        "descripcion": description,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}


