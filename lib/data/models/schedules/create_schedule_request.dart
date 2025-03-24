class CreateScheduleRequest {
  final List<String> dias;
  final String horaInicio;
  final String horaFin;
  final List<String> sectoresAsociados;
  final bool activo;
  final String observaciones;
  final String tipoBasura;

  CreateScheduleRequest({
    required this.dias,
    required this.horaInicio,
    required this.horaFin,
    required this.sectoresAsociados,
    required this.activo,
    required this.observaciones,
    required this.tipoBasura,
  });

  Map<String, dynamic> toJson() => {
        "dias": List<dynamic>.from(dias.map((x) => x)),
        "horaInicio": horaInicio,
        "horaFin": horaFin,
        "sectoresAsociados":
            List<dynamic>.from(sectoresAsociados.map((x) => x)),
        "activo": activo,
        "observaciones": observaciones,
        "tipoBasura": tipoBasura,
      };
}
