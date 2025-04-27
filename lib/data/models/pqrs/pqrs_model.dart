import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';

class PqrsModel {
  final String id;
  final String subject;
  final String description;
  final String radicadorId;
  final String radicadorName;
  final String radicadorPhone;
  final String radicadorEmail;
  final String radicadorDocument;
  final PqrsStatusEnum status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? closureDate;
  final String? resolucion;
  final String? resolverName;

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
    this.resolucion,
    this.resolverName
  });

  factory PqrsModel.fromMap(Map<String, dynamic> json) {
    // Función auxiliar para analizar fechas de forma segura
    DateTime? parseDate(dynamic dateStr) {
      if (dateStr == null || dateStr == '') return null;
      try {
        return DateTime.parse(dateStr.toString());
      } catch (e) {
        AppLogger.w('Error parsing date: $dateStr, error: $e');
        return DateTime.now(); // Fecha predeterminada en caso de error
      }
    }
    /// Funcion para obtener el esatdo formateado de acuerdo al valor retornado por el api
    PqrsStatusEnum getFormattedStatus(String status) {
      switch (status) {
        case 'pendiente':
          return PqrsStatusEnum.pendiente;
        case 'en proceso':
          return PqrsStatusEnum.EnProceso;
        case 'solucionado':
          return PqrsStatusEnum.solucionado;
        case 'cerrado':
          return PqrsStatusEnum.cerrado;
        case 'cancelado':
          return PqrsStatusEnum.cancelado;
        default:
          return PqrsStatusEnum.pendiente;
      }
    }

    // Analizar las fechas de forma segura
    final DateTime createdAtDate =
        parseDate(json["createdAt"]) ?? DateTime.now();
    final DateTime updatedAtDate =
        parseDate(json["updatedAt"]) ?? DateTime.now();
    final DateTime? closureDateValue = parseDate(json["fechaCierre"]);

    return PqrsModel(
      id: json["_id"] ?? '',
      subject: json["asunto"] ?? 'Sin Asunto',
      description: json["descripcion"] ?? '',
      radicadorId: json["idRadicador"] ?? '',
      radicadorName: json["nombreRadicador"] ?? 'Desconocido',
      radicadorPhone: json["telefonoRadicador"] ?? '',
      radicadorEmail: json["emailRadicador"] ?? '',
      radicadorDocument: json["documentoRadicador"] ?? '',
      status: getFormattedStatus(json["estado"]),
      createdAt: createdAtDate,
      updatedAt: updatedAtDate,
      closureDate: closureDateValue,
      resolucion: json["resolucion"],
      resolverName: json["resolverName"],
    );
  }

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
        "resolucion": resolucion,
        "nombreQuienResuelve": resolverName
      };

  String getFormattedUpdatedAt() {
    try {
      return updatedAt.toIso8601String();
    } catch (e) {
      return 'Fecha no disponible';
    }
  }

  // También podrías añadir otros métodos auxiliares para formatear fechas
  String getFormattedDate(DateTime? date,
      {String defaultValue = 'No disponible'}) {
    if (date == null) return defaultValue;
    try {
      // Puedes personalizar el formato según tus necesidades
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return defaultValue;
    }
  }
}
