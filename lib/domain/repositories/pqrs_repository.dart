import 'package:esvilla_app/domain/entities/pqrs/create_pqrs_request_entity.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/entities/pqrs/update_pqrs_request_entity.dart';
import 'package:esvilla_app/domain/repositories/generic_repository.dart';

abstract class PqrsRepository implements GenericRepository<PqrsEntity,CreatePqrsRequestEntity, UpdatePqrsRequestEntity>{
  
  Future<PqrsEntity> generatePqrs(CreatePqrsRequestEntity request);

  Future<PqrsEntity?> getMyPqrs();

  Future<List<PqrsEntity>> getPqrsByUser(String id);

  Future<PqrsEntity> closePqrs(UpdatePqrsRequestEntity request);
}