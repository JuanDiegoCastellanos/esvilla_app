class UpdateScheduleRequest {
    final String id;
    final List<String>? days;
    final String? startTime;
    final String? endTime;
    final List<String>? associatedSectors;
    final bool? active;
    final String? observations;
    final String? garbageType;

    UpdateScheduleRequest({
        required this.id,
        this.days,
        this.startTime,
        this.endTime,
        this.associatedSectors,
        this.active,
        this.observations,
        this.garbageType,
    });
    Map<String, dynamic> toJson(){
      final map = <String, dynamic>{'_id': id};

      if(days != null) map["dias"] = List<dynamic>.from(days!.map((x) => x));
      if(startTime != null) map["horaInicio"] = startTime;
      if(endTime != null) map["horaFin"] = endTime;
      if(associatedSectors != null) map["sectoresAsociados"] = List<dynamic>.from(associatedSectors!.map((x) => x));
      if(active != null) map["activo"] = active;
      if(observations != null) map["observaciones"] = observations;
      if(garbageType != null) map["tipoBasura"] = garbageType;

      return map;
    }
}
