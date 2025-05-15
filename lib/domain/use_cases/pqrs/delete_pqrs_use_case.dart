import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';

class DeletePqrsUseCase {
  final PqrsRepository repository;

  DeletePqrsUseCase(this.repository);

  Future<PqrsEntity> call(String id) async => await repository.delete(id);
  
}