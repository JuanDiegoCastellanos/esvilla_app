import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/entities/pqrs/update_pqrs_request_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';

class UpdatePqrsUseCase {
  final PqrsRepository repository;

  UpdatePqrsUseCase(this.repository);

  Future<PqrsEntity> call(String id ,UpdatePqrsRequestEntity request) async =>
      await repository.update(id,request);
}