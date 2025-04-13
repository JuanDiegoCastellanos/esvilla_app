import 'package:esvilla_app/domain/entities/pqrs/create_pqrs_request_entity.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';

class GeneratePqrsUseCase {
  final PqrsRepository repository;

  GeneratePqrsUseCase(this.repository);

  Future<PqrsEntity> call(CreatePqrsRequestEntity request) async =>
      await repository.generatePqrs(request);
}
