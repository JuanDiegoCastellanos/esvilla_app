import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';

class DeletePqrsUseCase {
  final PqrsRepository repository;

  DeletePqrsUseCase(this.repository);

  Future<void> call(String id) async => await repository.delete(id);
}