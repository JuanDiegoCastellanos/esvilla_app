import 'package:esvilla_app/domain/entities/sectors/create_sector_request_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/repositories/sectors_repository.dart';

class CreateSectorUseCase {
  final SectorsRepository _repository;

  CreateSectorUseCase(this._repository);

  Future<SectorEntity> call(CreateSectorRequestEntity request) async => await _repository.add(request);
}