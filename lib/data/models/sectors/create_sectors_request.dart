import 'package:esvilla_app/data/models/sectors/location_model.dart';

class CreateSectorRequest {
    final String name;
    final String description;
    final LocationModel location;

    CreateSectorRequest({
        required this.name,
        required this.description,
        required this.location,
    });

    factory CreateSectorRequest.fromMap(Map<String, dynamic> json) => CreateSectorRequest(
        name: json["nombre"],
        description: json["descripcion"],
        location: LocationModel.fromMap(json["ubicacion"]),
    );

    Map<String, dynamic> toJson() => {
        "nombre": name,
        "descripcion": description,
        "ubicacion": location.toJson(),
    };
}