import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/update_sector_request_entity.dart';
import 'package:esvilla_app/domain/repositories/sectors_repository.dart';

class UpdateSectorUseCase {
  final SectorsRepository _repository;

  UpdateSectorUseCase(this._repository);

  Future<SectorEntity> call(
          String id, UpdateSectorRequestEntity request) async =>
      await _repository.update(id, request);
}
