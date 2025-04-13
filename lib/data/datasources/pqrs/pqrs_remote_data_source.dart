import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/models/pqrs/pqrs_create_request.dart';
import 'package:esvilla_app/data/models/pqrs/pqrs_model.dart';
import 'package:esvilla_app/data/models/pqrs/pqrs_update_request.dart';

class PqrsRemoteDataSource {
  final Dio _dio;

  PqrsRemoteDataSource(this._dio);

  /// Crea un nuevo PQRS en el servidor.
  Future<PqrsModel> generatePqrs(CreatePqrsRequest request) async {
    try {
      final response = await _dio.post(
        '/pqrs',
        data: request.toJson(),
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PqrsModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to create PQRS. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to create PQRS. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during create PQRS: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during create PQRS: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  /// Obtiene todos los PQRS desde el servidor.
  Future<List<PqrsModel>> getPqrs() async {
    try {
      final response = await _dio.get(
        '/pqrs',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = response.data;
        return responseData
            .map((item) => PqrsModel.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        AppLogger.e(
            'Failed to get PQRS. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to get PQRS. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during get PQRS: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during get PQRS: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  /// Obtiene un PQRS por ID desde el servidor.
  Future<PqrsModel> getPqrsById(String id) async {
    try {
      final response = await _dio.get(
        '/pqrs/$id',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PqrsModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to get PQRS by ID. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to get PQRS by ID. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during get PQRS by ID: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during get PQRS by ID: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<List<PqrsModel>> getPqrsByUser(String id) async {
    try {
      final response = await _dio.get(
        '/pqrs/user/$id',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = response.data;
        return responseData
            .map((item) => PqrsModel.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        AppLogger.e(
            'Failed to get PQRS by ID. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to get PQRS by ID. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during get PQRS by ID: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during get PQRS by ID: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<PqrsModel> getMyPqrs() async {
    try {
      final response = await _dio.get(
        '/pqrs/my-pqrs',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PqrsModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to get My PQRS. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to get My PQRS. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during get My PQRS: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during get My PQRS: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  /// Actualiza un PQRS en el servidor.
  Future<PqrsModel> updatePqrs(UpdatePqrsRequest request) async {
    try {
      final response = await _dio.patch(
        '/pqrs/${request.id}',
        data: request.toJson(),
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PqrsModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to update PQRS. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to update PQRS. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during update PQRS: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during update PQRS: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  /// Actualiza un PQRS en el servidor.
  Future<PqrsModel> closePqrs(UpdatePqrsRequest request) async {
    try {
      final response = await _dio.patch(
        '/pqrs/${request.id}/close',
        data: request.toJson(),
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PqrsModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to update PQRS. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to update PQRS. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during update PQRS: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during update PQRS: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  /// Elimina un PQRS del servidor.
  Future<PqrsModel> deletePqrs(String id) async {
    try {
      final response = await _dio.delete(
        '/pqrs/$id',
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.i(
            'PQRS deleted successfully. Status: ${response.statusCode}');
        return PqrsModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to delete PQRS. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to delete PQRS. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during delete PQRS: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during delete PQRS: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }
}
