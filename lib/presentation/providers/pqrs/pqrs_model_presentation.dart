import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/domain/entities/pqrs/create_pqrs_request_entity.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';

class PqrsModelPresentation {
  final String? id;
  final String? subject;
  final String? description;
  final String? radicadorId;
  final String? radicadorName;
  final String? radicadorPhone;
  final String? radicadorEmail;
  final String? radicadorDocument;
  final PqrsStatusEnum? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? closureDate;
  final bool isLoading;
  final String? error;

  PqrsModelPresentation({
    this.id,
    this.subject,
    this.description,
    this.radicadorId,
    this.radicadorName,
    this.radicadorPhone,
    this.radicadorEmail,
    this.radicadorDocument,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.closureDate,
    this.isLoading = false,
    this.error,
  });

  PqrsModelPresentation copyWith({
    String? id,
    String? subject,
    String? description,
    String? radicadorId,
    String? radicadorName,
    String? radicadorPhone,
    String? radicadorEmail,
    String? radicadorDocument,
    PqrsStatusEnum? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? closureDate,
    bool? isLoading,
    String? error,
  }) {
    return PqrsModelPresentation(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      radicadorId: radicadorId ?? this.radicadorId,
      radicadorName: radicadorName ?? this.radicadorName,
      radicadorPhone: radicadorPhone ?? this.radicadorPhone,
      radicadorEmail: radicadorEmail ?? this.radicadorEmail,
      radicadorDocument: radicadorDocument ?? this.radicadorDocument,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      closureDate: closureDate ?? this.closureDate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  static PqrsModelPresentation fromEntity(PqrsEntity entity) {
    return PqrsModelPresentation(
      id: entity.id,
      subject: entity.subject,
      description: entity.description,
      radicadorId: entity.radicadorId,
      radicadorName: entity.radicadorName,
      radicadorPhone: entity.radicadorPhone,
      radicadorEmail: entity.radicadorEmail,
      radicadorDocument: entity.radicadorDocument,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      closureDate: entity.closureDate,
    );
  }

  static CreatePqrsRequestEntity toCreateRequestEntity(
      PqrsModelPresentation newPrs) {
    return CreatePqrsRequestEntity(
        subject: newPrs.subject!,
        description: newPrs.description!,
        status: "PENDIENTE");
  }
}
