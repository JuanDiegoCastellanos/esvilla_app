import 'package:esvilla_app/data/models/sectors/ubicacion_model.dart';

class SectorModel {
    final Ubicacion ubicacion;
    final String id;
    final String nombre;
    final String descripcion;
    final DateTime updatedAt;

    SectorModel({
        required this.ubicacion,
        required this.id,
        required this.nombre,
        required this.descripcion,
        required this.updatedAt,
    });

    factory SectorModel.fromMap(Map<String, dynamic> json) => SectorModel(
        ubicacion: Ubicacion.fromMap(json["ubicacion"]),
        id: json["_id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "ubicacion": ubicacion.toJson(),
        "_id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "updatedAt": updatedAt.toIso8601String(),
    };
}


