class CreateScheduleRequest {
  final List<String> days;
  final String startTime;
  final String endTime;
  final List<String> associatedSectors;
  final bool active;
  final String observations;
  final String garbageType;

  CreateScheduleRequest({
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.associatedSectors,
    required this.active,
    required this.observations,
    required this.garbageType,
  });

  Map<String, dynamic> toJson() => {
        "dias": List<dynamic>.from(days.map((x) => x)),
        "horaInicio": startTime,
        "horaFin": endTime,
        "sectoresAsociados":
            List<dynamic>.from(associatedSectors.map((x) => x)),
        "activo": active,
        "observaciones": observations,
        "tipoBasura": garbageType,
      };
}

