import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/models/sectors/create_sectors_request.dart';
import 'package:esvilla_app/data/models/sectors/sector_model.dart';
import 'package:esvilla_app/data/models/sectors/update_sectors_request.dart';

class SectorsRemoteDataSource {
  final Dio _dio;

  SectorsRemoteDataSource(this._dio);

  Future<List<SectorModel>> getSectors() async {
    try {
      final response = await _dio.get(
        '/sectors',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = response.data;
        return responseData.map((item) => SectorModel.fromMap(item)).toList();
      } else {
        AppLogger.e(
            'Failed to get sectors. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to get sectors. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during get sectors: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during get sectors: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<SectorModel> getSectorById(String id) async {
    try {
      final response = await _dio.get(
        '/sectors/$id',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SectorModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to get sector. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to get sector. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during get sector: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during get sector: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<SectorModel> createSector(CreateSectorRequest createSectorRequest) async {
    try {
      final response = await _dio.post(
        '/sectors',
        data: createSectorRequest.toJson(),
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SectorModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to create sector. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to create sector. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during create sector: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during create sector: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<SectorModel> updateSector(UpdateSectorsRequest updateSectorsRequest) async {
    try {
      final response = await _dio.patch(
        '/sectors/${updateSectorsRequest.id}',
        data: updateSectorsRequest.toJson(),
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SectorModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to update sector. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to update sector. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during update sector: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during update sector: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<SectorModel> deleteSector(String id) async {
    try {
      final response = await _dio.delete(
        '/sectors/$id',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SectorModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to delete sector. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to delete sector. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during delete sector: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during delete sector: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

}
