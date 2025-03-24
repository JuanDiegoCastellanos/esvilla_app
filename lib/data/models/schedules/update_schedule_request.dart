class UpdateScheduleRequest {
    final String id;
    final List<String>? dias;
    final String? horaInicio;
    final String? horaFin;
    final List<String>? sectoresAsociados;
    final bool? activo;
    final String? observaciones;
    final String? tipoBasura;

    UpdateScheduleRequest({
        required this.id,
        this.dias,
        this.horaInicio,
        this.horaFin,
        this.sectoresAsociados,
        this.activo,
        this.observaciones,
        this.tipoBasura,
    });
    Map<String, dynamic> toJson(){
      final map = <String, dynamic>{'_id': id};

      if(dias != null) map["dias"] = List<dynamic>.from(dias!.map((x) => x));
      if(horaInicio != null) map["horaInicio"] = horaInicio;
      if(horaFin != null) map["horaFin"] = horaFin;
      if(sectoresAsociados != null) map["sectoresAsociados"] = List<dynamic>.from(sectoresAsociados!.map((x) => x));
      if(activo != null) map["activo"] = activo;
      if(observaciones != null) map["observaciones"] = observaciones;
      if(tipoBasura != null) map["tipoBasura"] = tipoBasura;

      return map;
    }
}
