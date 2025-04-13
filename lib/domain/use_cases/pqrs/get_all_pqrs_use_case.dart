import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';

class GetAllPqrsUseCase {
  final PqrsRepository repository;

  GetAllPqrsUseCase(this.repository);

  Future<List<PqrsEntity>> call() async => await repository.getAll();
}