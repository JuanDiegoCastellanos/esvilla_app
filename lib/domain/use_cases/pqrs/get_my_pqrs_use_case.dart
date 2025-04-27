import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';

class GetMyPqrsUseCase {
  final PqrsRepository _repository;

  GetMyPqrsUseCase(this._repository);

  Future<PqrsEntity?> call() async => await _repository.getMyPqrs();
}