class PqrsModel {
    final String id;
    final String asunto;
    final String descripcion;
    final String idRadicador;
    final String nombreRadicador;
    final String telefonoRadicador;
    final String emailRadicador;
    final String documentoRadicador;
    final String estado;
    final DateTime fechaCierre;
    final DateTime createdAt;
    final DateTime updatedAt;
    

    PqrsModel({
        required this.id,
        required this.asunto,
        required this.descripcion,
        required this.idRadicador,
        required this.nombreRadicador,
        required this.telefonoRadicador,
        required this.emailRadicador,
        required this.documentoRadicador,
        required this.estado,
        required this.createdAt,
        required this.updatedAt,
        required this.fechaCierre,
    });

    factory PqrsModel.fromMap(Map<String, dynamic> json) => PqrsModel(
        id: json["_id"],
        asunto: json["asunto"],
        descripcion: json["descripcion"],
        idRadicador: json["idRadicador"],
        nombreRadicador: json["nombreRadicador"],
        telefonoRadicador: json["telefonoRadicador"],
        emailRadicador: json["emailRadicador"],
        documentoRadicador: json["documentoRadicador"],
        estado: json["estado"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        fechaCierre: DateTime.parse(json["fechaCierre"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "asunto": asunto,
        "descripcion": descripcion,
        "idRadicador": idRadicador,
        "nombreRadicador": nombreRadicador,
        "telefonoRadicador": telefonoRadicador,
        "emailRadicador": emailRadicador,
        "documentoRadicador": documentoRadicador,
        "estado": estado,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "fechaCierre": fechaCierre.toIso8601String(),
    };
}
