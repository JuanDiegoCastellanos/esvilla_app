class UpdatePqrsRequest{
    final String id;
    final String? subject;
    final String? description;
    final String? radicadorId;
    final String? radicadorName;
    final String? radicadorPhone;
    final String? radicadorEmail;
    final String? radicadorDocument;
    final String? status;
    final DateTime? closureDate;
    final String? resolucion;
    final String? resolverName;

    UpdatePqrsRequest({
      required this.id,
      this.subject,
      this.description,
      this.radicadorId,
      this.radicadorName,
      this.radicadorPhone,
      this.radicadorEmail,
      this.radicadorDocument,
      this.status,
      this.closureDate,
      this.resolucion,
      this.resolverName
    });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'_id': id};
    if (subject != null) map['asunto'] = subject;
    if (description != null) map['descripcion'] = description;
    if (radicadorId != null) map['idRadicador'] = radicadorId;
    if (radicadorName != null) map['nombreRadicador'] = radicadorName;
    if (radicadorPhone != null) map['telefonoRadicador'] = radicadorPhone;
    if (radicadorEmail != null) map['emailRadicador'] = radicadorEmail;
    if (radicadorDocument != null) map['documentoRadicador'] = radicadorDocument;
    if (status != null) map['estado'] = status;
    if (closureDate != null) map['fechaCierre'] = closureDate!.toIso8601String();
    if (resolucion != null) map['resolucion'] = resolucion;
    if (resolverName != null) map['nombreQuienResuelve'] = resolverName;
    return map;
  }
}
