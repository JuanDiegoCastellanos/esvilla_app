class CreatePqrsRequest{
    final String asunto;
    final String descripcion;
    final String idRadicador;
    final String nombreRadicador;
    final String telefonoRadicador;
    final String emailRadicador;
    final String documentoRadicador;
    final String estado;
    final DateTime fechaCierre;

    CreatePqrsRequest({
      required this.asunto,
      required this.descripcion,
      required this.idRadicador,
      required this.nombreRadicador,
      required this.telefonoRadicador,
      required this.emailRadicador,
      required this.documentoRadicador,
      required this.estado,
      required this.fechaCierre
    });

  Map<String, dynamic> toJson() => {
        "asunto": asunto,
        "descripcion": descripcion,
        "idRadicador": idRadicador,
        "nombreRadicador": nombreRadicador,
        "telefonoRadicador": telefonoRadicador,
        "emailRadicador": emailRadicador,
        "documentoRadicador": documentoRadicador,
        "estado": estado,
        "fechaCierre": fechaCierre.toIso8601String(),
      };  
}