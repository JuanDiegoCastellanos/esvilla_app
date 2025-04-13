class PqrsModel {
  final String id;
  final String subject;
  final String description;
  final String radicadorId;
  final String radicadorName;
  final String radicadorPhone;
  final String radicadorEmail;
  final String radicadorDocument;
  final String status;
  final DateTime? closureDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  PqrsModel({
    required this.id,
    required this.subject,
    required this.description,
    required this.radicadorId,
    required this.radicadorName,
    required this.radicadorPhone,
    required this.radicadorEmail,
    required this.radicadorDocument,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.closureDate,
  });

  factory PqrsModel.fromMap(Map<String, dynamic> json) => PqrsModel(
    id: json["_id"],
    subject: json["asunto"],
    description: json["descripcion"],
    radicadorId: json["idRadicador"],
    radicadorName: json["nombreRadicador"],
    radicadorPhone: json["telefonoRadicador"],
    radicadorEmail: json["emailRadicador"],
    radicadorDocument: json["documentoRadicador"],
    status: json["estado"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    closureDate: DateTime.parse(json["fechaCierre"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "asunto": subject,
    "descripcion": description,
    "idRadicador": radicadorId,
    "nombreRadicador": radicadorName,
    "telefonoRadicador": radicadorPhone,
    "emailRadicador": radicadorEmail,
    "documentoRadicador": radicadorDocument,
    "estado": status,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "fechaCierre": closureDate?.toIso8601String(),
  };
}

