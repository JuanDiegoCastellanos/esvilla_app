import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';

class GetPqrsByIdUseCase {
  final PqrsRepository repository;

  GetPqrsByIdUseCase(this.repository);

  Future<PqrsEntity> call(String id) async => await repository.getById(id);
}
