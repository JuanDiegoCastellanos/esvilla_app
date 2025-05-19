import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/models/schedules/add_sectors_request.dart';
import 'package:esvilla_app/data/models/schedules/create_schedule_request.dart';
import 'package:esvilla_app/data/models/schedules/schedule_model.dart';
import 'package:esvilla_app/data/models/schedules/update_schedule_request.dart';
import 'package:esvilla_app/data/models/schedules/update_sectors_schedule_request.dart';

class SchedulesRemoteDataSource {
  final Dio _dio;

  SchedulesRemoteDataSource(this._dio);

  Future<List<ScheduleModel>> getSchedules() async {
    try {
      final response = await _dio.get(
        '/schedules',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = response.data;
        return responseData.map((item) => ScheduleModel.fromMap(item)).toList();
      } else {
        AppLogger.e(
            'Failed to get schedules. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to get schedules. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during get schedules: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during get schedules: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<ScheduleModel> getSchedulesByID(String id) async {
    try {
      final response = await _dio.get(
        '/schedules/$id',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ScheduleModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to get announcements. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to get announcements. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during get announcements: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during get announcements: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<List<String>> getSectorsByScheduleID(String id) async {
    try {
      final response = await _dio.get(
        '/schedules/$id/sectors',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = response.data;
        return responseData.map<String>((e) => e.toString()).toList();
      } else {
        AppLogger.e(
            'Failed to get sectors of schedule. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to get sectors of schedule. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e, t) {
      AppLogger.e('Dio error during get sectors of schedule : $e , $t');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e, t) {
      AppLogger.e('Unexpected error during get : $e , $t');
      rethrow;
    }
  }

  Future<ScheduleModel> getScheduleOfASector(String id) async {
    try{
        final response = await _dio.get(
          '/schedules/sectors/$id',
        );
        if(response.statusCode == 200 || response.statusCode == 201){
          AppLogger.i('Response Data: ${response.data}');
          return ScheduleModel.fromMap(response.data);
        }else{
          AppLogger.e(
            'Failed to get schedules. Status: ${response.statusCode}, Body: ${response.data}'
          );
          throw Exception(
            'Failed to get schedules. Status: ${response.statusCode}, Body: ${response.data}'
          );
        }
    }on DioException catch (e) {
      AppLogger.e('Dio error during get announcements: $e');
      throw AppException.fromDioExceptionType(e.type);
    }catch(e){
      AppLogger.e('Unexpected error during get announcements: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<ScheduleModel> createSchedule(
    CreateScheduleRequest createScheduleRequest
  ) async {
    try{
      final response = await _dio.post(
        '/schedules',
        data: createScheduleRequest.toJson(),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        AppLogger.i('Response Data: ${response.data}');
        return ScheduleModel.fromMap(response.data);
      }else{
          AppLogger.e(
            'Failed to create schedules. Status: ${response.statusCode}, Body: ${response.data}'
          );
          throw Exception(
            'Failed to create schedules. Status: ${response.statusCode}, Body: ${response.data}'
          );
        }
    }on DioException catch (e){
      AppLogger.e('Dio error during create announcements: $e');
      throw AppException.fromDioExceptionType(e.type);
    }catch(e){
      AppLogger.e('Unexpected error during create announcements: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<ScheduleModel> updateSchedule(
    UpdateScheduleRequest updateScheduleRequest
  ) async {
    try{
      final response = await _dio.patch(
        'schedules/${updateScheduleRequest.id}',
        data: updateScheduleRequest.toJson(),
      );
      AppLogger.i('Response Data: ${response.data}');
      if(response.statusCode == 200 || response.statusCode == 201){
        AppLogger.i('Response Data: ${response.data}');
        return ScheduleModel.fromMap(response.data);
      }else {
        AppLogger.e(
            'Failed to update schedules. Status: ${response.statusCode}, Body: ${response.data}'
          );
          throw Exception(
            'Failed to update schedules. Status: ${response.statusCode}, Body: ${response.data}'
          );
      }
    }on DioException catch (e){
      AppLogger.e('Dio error during update announcements: $e');
      throw AppException.fromDioExceptionType(e.type);
    }catch(e){
      AppLogger.e('Unexpected error during update announcements: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  // del horario tal quiero cambiar los sectores, agregar o remover tal vez
  Future<ScheduleModel> updateSectorsFromSchedule(
    String id,UpdateSectorsScheduleRequest updateSectorsRequest
  ) async {
    try{
      final response = await _dio.patch(
        'schedules/$id/sectors',
        data: updateSectorsRequest.toJson(),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        AppLogger.i('Response Data: ${response.data}');
        return ScheduleModel.fromMap(response.data);
      }else {
        AppLogger.e(
            'Failed to update schedules. Status: ${response.statusCode}, Body: ${response.data}'
          );
          throw Exception(
            'Failed to update schedules. Status: ${response.statusCode}, Body: ${response.data}'
          );
      }
    }on DioException catch (e){
      AppLogger.e('Dio error during update announcements: $e');
      throw AppException.fromDioExceptionType(e.type);
    }catch(e){
      AppLogger.e('Unexpected error during update announcements: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
    
  }

  Future<ScheduleModel> addSectorsToSchedule(
    String id,AddSectorsRequest addSectorsRequest
  ) async {
    try{
      final response = await _dio.patch(
        'schedules/$id/add-sectors',
        data: addSectorsRequest.toJson(),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        AppLogger.i('Response Data: ${response.data}');
        return ScheduleModel.fromMap(response.data);
      }else {
        AppLogger.e(
            'Failed to add schedules. Status: ${response.statusCode}, Body: ${response.data}'
          );
          throw Exception(
            'Failed to add schedules. Status: ${response.statusCode}, Body: ${response.data}'
          );
      }
    }on DioException catch (e){
      AppLogger.e('Dio error during add announcements: $e');
      throw AppException.fromDioExceptionType(e.type);
    }catch(e){
      AppLogger.e('Unexpected error during add announcements: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<ScheduleModel> deleteSchedule(
    String id
  ) async{
    try{
      final response = await _dio.delete(
        'schedules/$id',
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        AppLogger.i('Response Data: ${response.data}');
        return ScheduleModel.fromMap(response.data);
      }else {
        AppLogger.e(
            'Failed to delete schedules. Status: ${response.statusCode}, Body: ${response.data}'
          );
          throw Exception(
            'Failed to delete schedules. Status: ${response.statusCode}, Body: ${response.data}'
          );
      }
    }on DioException catch (e){
      AppLogger.e('Dio error during delete announcements: $e');
      throw AppException.fromDioExceptionType(e.type);
    }catch(e){
      AppLogger.e('Unexpected error during delete announcements: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

}
