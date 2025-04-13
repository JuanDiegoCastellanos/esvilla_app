import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/datasources/sectors/sectors_remote_data_source.dart';
import 'package:esvilla_app/data/mappers/sector/sector_mapper.dart';
import 'package:esvilla_app/domain/entities/sectors/create_sector_request_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/update_sector_request_entity.dart';
import 'package:esvilla_app/domain/repositories/sectors_repository.dart';

class SectorRepositoryImpl implements SectorsRepository {
  final SectorsRemoteDataSource _sectorsRemoteDataSource;

  SectorRepositoryImpl(this._sectorsRemoteDataSource);

  @override
  Future<SectorEntity> add(CreateSectorRequestEntity entity) async {
    try {
      final createSectorRequest = SectorMapper.toRequest(entity);
      final sectorModelResponse =
          await _sectorsRemoteDataSource.createSector(createSectorRequest);
      return SectorMapper.toEntity(sectorModelResponse);
    } catch (e) {
      throw AppException(code: -1, message: 'Error with create sector');
    }
  }

  @override
  Future<SectorEntity> delete(String id) async {
    try {
      final sectorModelResponse =
          await _sectorsRemoteDataSource.deleteSector(id);
      return SectorMapper.toEntity(sectorModelResponse);
    } catch (e) {
      throw AppException(code: -1, message: 'Error with delete sector');
    }
  }

  @override
  Future<List<SectorEntity>> getAll() async {
    try {
      final listSectorsModelResponse =
          await _sectorsRemoteDataSource.getSectors();
      return SectorMapper.toEntityList(listSectorsModelResponse);
    } catch (e) {
      throw AppException(code: -1, message: 'Error with get sectors');
    }
  }

  @override
  Future<SectorEntity> getById(String id) async {
    try {
      final sectorModelResponse = await _sectorsRemoteDataSource.getSectorById(id);
      return SectorMapper.toEntity(sectorModelResponse);
    } catch (e) {
      throw AppException(code: -1, message: 'Error with get sector by id');
    }
  }

  @override
  Future<SectorEntity> update(
      String id, UpdateSectorRequestEntity entity) async {
    try {
      final updateSectorRequest = SectorMapper.toUpdateRequest(entity);
      final sectorModelResponse = await _sectorsRemoteDataSource.updateSector(updateSectorRequest);
      return SectorMapper.toEntity(sectorModelResponse);
    } catch (e) {
      throw AppException(code: -1, message: 'Error with update sector');
    }
  }
}
