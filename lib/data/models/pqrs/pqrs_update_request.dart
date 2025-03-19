class UpdatePqrsRequest{
    final String id;
    final String? asunto;
    final String? descripcion;
    final String? idRadicador;
    final String? nombreRadicador;
    final String? telefonoRadicador;
    final String? emailRadicador;
    final String? documentoRadicador;
    final String? estado;
    final DateTime? fechaCierre;

    UpdatePqrsRequest({
      required this.id,
      this.asunto,
      this.descripcion,
      this.idRadicador,
      this.nombreRadicador,
      this.telefonoRadicador,
      this.emailRadicador,
      this.documentoRadicador,
      this.estado,
      this.fechaCierre
    });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'_id': id};
    
    if (asunto != null) map['asunto'] = asunto;
    if (descripcion != null) map['descripcion'] = descripcion;
    if (idRadicador != null) map['idRadicador'] = idRadicador;
    if (nombreRadicador != null) map['nombreRadicador'] = nombreRadicador;
    if (telefonoRadicador != null) map['telefonoRadicador'] = telefonoRadicador;
    if (emailRadicador != null) map['emailRadicador'] = emailRadicador;
    if (documentoRadicador != null) map['documentoRadicador'] = documentoRadicador;
    if (estado != null) map['estado'] = estado;
    if (fechaCierre != null) map['fechaCierre'] = fechaCierre!.toIso8601String();

    return map;
  }
}