import 'package:esvilla_app/data/models/sectors/ubicacion_model.dart';

class UpdateSectorsRequest {
    final String id;
    final String? nombre;
    final String? descripcion;
    final Ubicacion? ubicacion;

    UpdateSectorsRequest({
        required this.id,
        this.nombre,
        this.descripcion,
        this.ubicacion,
    });

    Map<String, dynamic> toJson(){
        final map = <String, dynamic>{'_id': id};
        if(nombre != null) map["nombre"] = nombre;
        if(descripcion != null) map["descripcion"] = descripcion;
        if(ubicacion != null) map["ubicacion"] = ubicacion!.toJson();

      return map;
    }
}