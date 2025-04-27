import 'package:esvilla_app/data/models/pqrs/pqrs_create_request.dart';
import 'package:esvilla_app/data/models/pqrs/pqrs_model.dart';
import 'package:esvilla_app/data/models/pqrs/pqrs_update_request.dart';
import 'package:esvilla_app/domain/entities/pqrs/create_pqrs_request_entity.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/entities/pqrs/update_pqrs_request_entity.dart';

class PqrsMapper {
  static PqrsEntity toEntity(PqrsModel model) => PqrsEntity(
        id: model.id,
        subject: model.subject,
        description: model.description,
        radicadorId: model.radicadorId,
        radicadorName: model.radicadorName,
        radicadorPhone: model.radicadorPhone,
        radicadorEmail: model.radicadorEmail,
        radicadorDocument: model.radicadorDocument,
        status: model.status,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        closureDate: model.closureDate,
        resolucion: model.resolucion,
        resolverName: model.resolverName
      );
  static PqrsModel toModel(PqrsEntity entity) => PqrsModel(
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
        resolucion: entity.resolucion,
        resolverName: entity.resolverName
      );

  static List<PqrsEntity> toEntityList(List<PqrsModel> models) =>
      models.map((model) => toEntity(model)).toList();

  static List<PqrsModel> toModelList(List<PqrsEntity> entities) =>
      entities.map((entity) => toModel(entity)).toList();

  static CreatePqrsRequest toCreateRequest(CreatePqrsRequestEntity entity) =>
      CreatePqrsRequest(
          subject: entity.subject,
          description: entity.description,
          status: entity.status);

  static UpdatePqrsRequest toUpdateRequest(UpdatePqrsRequestEntity entity) =>
      UpdatePqrsRequest(
          id: entity.id,
          subject: entity.subject,
          description: entity.description,
          radicadorId: entity.radicadorId,
          radicadorName: entity.radicadorName,
          radicadorPhone: entity.radicadorPhone,
          radicadorEmail: entity.radicadorEmail,
          radicadorDocument: entity.radicadorDocument,
          status: entity.status,
          closureDate: entity.closureDate,
          resolucion: entity.resolucion,
          resolverName: entity.resolverName
          );
}
