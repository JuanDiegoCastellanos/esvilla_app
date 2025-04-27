import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/datasources/pqrs/pqrs_remote_data_source.dart';
import 'package:esvilla_app/data/mappers/pqrs/pqrs_mapper.dart';
import 'package:esvilla_app/domain/entities/pqrs/create_pqrs_request_entity.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:esvilla_app/domain/entities/pqrs/update_pqrs_request_entity.dart';
import 'package:esvilla_app/domain/repositories/pqrs_repository.dart';

class PqrsRepositoryImpl implements PqrsRepository {
  final PqrsRemoteDataSource _pqrsRemoteDataSource;

  PqrsRepositoryImpl(this._pqrsRemoteDataSource);

  @override
  Future<PqrsEntity> add(CreatePqrsRequestEntity entity) async {
    try {
      final response = await _pqrsRemoteDataSource
          .generatePqrs(PqrsMapper.toCreateRequest(entity));
      return PqrsMapper.toEntity(response);
    } catch (e) {
      AppLogger.e('Unexpected error during create PQRS: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  @override
  Future<PqrsEntity> delete(String id) async {
    try {
      if (id.isNotEmpty) {
        final response = await _pqrsRemoteDataSource.deletePqrs(id);
        return PqrsMapper.toEntity(response);
      } else {
        throw AppException(code: -1, message: 'Id is empty');
      }
    } catch (e) {
      AppLogger.e('Unexpected error during create PQRS: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  @override
  Future<PqrsEntity> generatePqrs(CreatePqrsRequestEntity entity) async {
    try {
      final response = await _pqrsRemoteDataSource
          .generatePqrs(PqrsMapper.toCreateRequest(entity));
      return PqrsMapper.toEntity(response);
    } catch (e) {
      AppLogger.e('Unexpected error during create PQRS: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  @override
  Future<List<PqrsEntity>> getAll() async {
    try {
      final response = await _pqrsRemoteDataSource.getPqrs();
      return PqrsMapper.toEntityList(response);
    } catch (e) {
      AppLogger.e('Unexpected error during get PQRS: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  @override
  Future<PqrsEntity> getById(String id) async {
    try {
      if (id.isNotEmpty) {
        final response = await _pqrsRemoteDataSource.getPqrsById(id);
        return PqrsMapper.toEntity(response);
      } else {
        throw AppException(code: -1, message: 'Id is empty');
      }
    } catch (e) {
      AppLogger.e('Unexpected error during get PQRS by ID: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  @override
  Future<PqrsEntity?> getMyPqrs() async {
    try {
      final response = await _pqrsRemoteDataSource.getMyPqrs();
      return response != null ? PqrsMapper.toEntity(response) : null;
    } catch (e) {
      AppLogger.e('Unexpected error during get My PQRS: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  @override
  Future<PqrsEntity> update(String id, UpdatePqrsRequestEntity entity) async {
    try {
      if (id.isEmpty || id != entity.id) {
        AppLogger.e('The id can not be empty or is not the same');
        throw AppException(
            message: 'The id can not be empty or is not the same');
      }
      final pqrsToUpdate = PqrsMapper.toUpdateRequest(entity);
      final pqrsUpdatedModel = await _pqrsRemoteDataSource.updatePqrs(pqrsToUpdate);
      return PqrsMapper.toEntity(pqrsUpdatedModel);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }
  
  @override
  Future<PqrsEntity> closePqrs(UpdatePqrsRequestEntity request) async{
    try {
      final closePqrsRequest = PqrsMapper.toUpdateRequest(request);
      final response = await  _pqrsRemoteDataSource.closePqrs(closePqrsRequest);
      return PqrsMapper.toEntity(response);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }
  
  @override
  Future<List<PqrsEntity>> getPqrsByUser(String id) async {
    try {
      final response = await _pqrsRemoteDataSource.getPqrsByUser(id);
      return PqrsMapper.toEntityList(response);
    }catch(e){
      throw AppException(message: e.toString());
    }
  }
}
