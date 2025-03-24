import 'package:esvilla_app/data/models/sectors/ubicacion_model.dart';

class CreateSectorRequest {
    final String nombre;
    final String descripcion;
    final Ubicacion ubicacion;

    CreateSectorRequest({
        required this.nombre,
        required this.descripcion,
        required this.ubicacion,
    });

    factory CreateSectorRequest.fromMap(Map<String, dynamic> json) => CreateSectorRequest(
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        ubicacion: Ubicacion.fromMap(json["ubicacion"]),
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "descripcion": descripcion,
        "ubicacion": ubicacion.toJson(),
    };
}