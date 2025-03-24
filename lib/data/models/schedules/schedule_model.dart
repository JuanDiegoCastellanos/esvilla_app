class ScheduleModel {
    final String id;
    final List<String> dias;
    final String horaInicio;
    final String horaFin;
    final List<String> sectoresAsociados;
    final bool activo;
    final String observaciones;
    final String tipoBasura;
    final DateTime createdAt;
    final DateTime updatedAt;

    ScheduleModel({
        required this.id,
        required this.dias,
        required this.horaInicio,
        required this.horaFin,
        required this.sectoresAsociados,
        required this.activo,
        required this.observaciones,
        required this.tipoBasura,
        required this.createdAt,
        required this.updatedAt,
    });

    factory ScheduleModel.fromMap(Map<String, dynamic> json) => ScheduleModel(
        id: json["_id"],
        dias: List<String>.from(json["dias"].map((x) => x)),
        horaInicio: json["horaInicio"],
        horaFin: json["horaFin"],
        sectoresAsociados: List<String>.from(json["sectoresAsociados"].map((x) => x)),
        activo: json["activo"],
        observaciones: json["observaciones"],
        tipoBasura: json["tipoBasura"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "dias": List<dynamic>.from(dias.map((x) => x)),
        "horaInicio": horaInicio,
        "horaFin": horaFin,
        "sectoresAsociados": List<dynamic>.from(sectoresAsociados.map((x) => x)),
        "activo": activo,
        "observaciones": observaciones,
        "tipoBasura": tipoBasura,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
