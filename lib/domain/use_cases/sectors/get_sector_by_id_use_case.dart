import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/repositories/sectors_repository.dart';

class GetSectorByIdUseCase {
  final SectorsRepository _repository;

  GetSectorByIdUseCase(this._repository);

  Future<SectorEntity> call(String id) async => await _repository.getById(id);
}