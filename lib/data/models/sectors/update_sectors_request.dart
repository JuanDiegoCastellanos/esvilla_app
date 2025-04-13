import 'package:esvilla_app/data/models/sectors/location_model.dart';

class UpdateSectorsRequest {
  final String id;
  final String? name;
  final String? description;
  final LocationModel? location;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  UpdateSectorsRequest({
    required this.id,
    this.name,
    this.description,
    this.location,
    this.createdAt,
    this.updatedAt
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'_id': id};
    if (name != null) map["nombre"] = name;
    if (description != null) map["descripcion"] = description;
    if (location != null) map["ubicacion"] = location!.toJson();
    if (createdAt != null) map["createdAt"] = createdAt!.toIso8601String();
    if (updatedAt != null) map["updatedAt"] = updatedAt!.toIso8601String();

    return map;
  }
}
