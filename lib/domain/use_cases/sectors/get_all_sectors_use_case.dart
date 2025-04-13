import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/repositories/sectors_repository.dart';

class GetAllSectorsUseCase {
  final SectorsRepository _repository;

  GetAllSectorsUseCase(this._repository);

  Future<List<SectorEntity>> call() async => await _repository.getAll();
}