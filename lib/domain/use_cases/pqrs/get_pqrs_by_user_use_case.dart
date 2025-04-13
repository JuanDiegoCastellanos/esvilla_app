import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';

class GetPqrsByUserUseCase {
  final PqrsRepository _repository;

  GetPqrsByUserUseCase(this._repository);

  Future<List<PqrsEntity>> call(String id) async => await _repository.getPqrsByUser(id);
}