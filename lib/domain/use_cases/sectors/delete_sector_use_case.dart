import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/repositories/sectors_repository.dart';

class DeleteSectorUseCase {
  final SectorsRepository _repository;

  DeleteSectorUseCase(this._repository);

  Future<SectorEntity> call(String id) async => await _repository.delete(id);
}