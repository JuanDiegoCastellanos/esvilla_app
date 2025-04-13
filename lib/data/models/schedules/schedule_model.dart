class ScheduleModel {
    final String id;
    final List<String> days;
    final String startTime;
    final String endTime;
    final List<String> associatedSectors;
    final bool active;
    final String observations;
    final String garbageType;
    final DateTime createdAt;
    final DateTime updatedAt;

    ScheduleModel({
        required this.id,
        required this.days,
        required this.startTime,
        required this.endTime,
        required this.associatedSectors,
        required this.active,
        required this.observations,
        required this.garbageType,
        required this.createdAt,
        required this.updatedAt,
    });

    factory ScheduleModel.fromMap(Map<String, dynamic> json) => ScheduleModel(
        id: json["_id"],
        days: List<String>.from(json["dias"].map((x) => x)),
        startTime: json["horaInicio"],
        endTime: json["horaFin"],
        associatedSectors: List<String>.from(json["sectoresAsociados"].map((x) => x)),
        active: json["activo"],
        observations: json["observaciones"],
        garbageType: json["tipoBasura"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "dias": List<dynamic>.from(days.map((x) => x)),
        "horaInicio": startTime,
        "horaFin": endTime,
        "sectoresAsociados": List<dynamic>.from(associatedSectors.map((x) => x)),
        "activo": active,
        "observaciones": observations,
        "tipoBasura": garbageType,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}

