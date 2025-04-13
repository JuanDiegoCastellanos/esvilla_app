import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/datasources/schedules/schedules_remote_data_source.dart';
import 'package:esvilla_app/data/mappers/schedules/schedules_mapper.dart';
import 'package:esvilla_app/domain/entities/schedules/create_schedule_request_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/schedule_entity.dart';
import 'package:esvilla_app/domain/entities/schedules/update_schedule_request_entity.dart';
import 'package:esvilla_app/domain/repositories/schedules_repository.dart';

class SchedulesRepositoryImpl implements SchedulesRepository{

  final SchedulesRemoteDataSource _schedulesRemoteDataSource;

  SchedulesRepositoryImpl(this._schedulesRemoteDataSource);

  @override
  Future<ScheduleEntity> add(CreateScheduleRequestEntity entity) async {
    try {
      final request = SchedulesMapper.toCreateRequest(entity);
      final response = await  _schedulesRemoteDataSource.createSchedule(request);
      return SchedulesMapper.toEntity(response);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<ScheduleEntity> delete(String id) async {
    try {
      final response = await _schedulesRemoteDataSource.deleteSchedule(id);
      return SchedulesMapper.toEntity(response);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<List<ScheduleEntity>> getAll() async {
    try {
      final response = await _schedulesRemoteDataSource.getSchedules();
      return SchedulesMapper.toEntityList(response);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<ScheduleEntity> getById(String id) async {
    try {
      final response = await _schedulesRemoteDataSource.getSchedulesByID(id);
      return SchedulesMapper.toEntity(response);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<ScheduleEntity> update(String id, UpdateScheduleRequestEntity entity) async {
    try {
      final request = SchedulesMapper.toUpdateRequest(entity);
      final response = await _schedulesRemoteDataSource.updateSchedule(request);
      return SchedulesMapper.toEntity(response);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

}