import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/models/announcements/announcements_model.dart';
import 'package:esvilla_app/data/models/announcements/announcements_query_params.dart';
import 'package:esvilla_app/data/models/announcements/create_announcement_request.dart';
import 'package:esvilla_app/data/models/announcements/paginated_reponse.dart';
import 'package:esvilla_app/data/models/announcements/update_announcements_request.dart';

class AnnouncementsRemoteDataSource {
  final Dio _dio;

  AnnouncementsRemoteDataSource(this._dio);

  /// Gets all announcements from the server.
  ///
  /// [token] is the JSON Web Token used to authenticate the request.
  ///
  /// Returns a list of [AnnouncementModel] representing all announcements.
  ///
  /// Throws an [AppException] if a network error or unexpected error occurs.
  Future<List<AnnouncementModel>> getAnnouncements() async {
    try {
      final response = await _dio.get(
        '/announcements',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = response.data;
        return responseData
            .map((item) => AnnouncementModel.fromMap(item))
            .toList();
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

  Future<PaginatedResponse<AnnouncementModel>> getAnnouncementsWithPagination(AnnouncementsQueryParams queryParams) async {
    try {
      final response = await _dio.get(
        '/announcements',
        queryParameters: queryParams.toMap(),
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaginatedResponse<AnnouncementModel>.fromJson(
          response.data,
          (json) => AnnouncementModel.fromMap(json),
          );
      } else {
        AppLogger.e(
            'Failed to get announcements--Logger ${response.statusCode}, Body: ${response.data}');

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

  /// Gets all the announcements created by the user from the server.
  ///
  /// [token] is the JSON Web Token used to authenticate the request.
  ///
  /// Returns a list of [AnnouncementModel] representing all announcements
  /// created by the user.
  ///
  /// Throws an [AppException] if a network error or unexpected error occurs.
  Future<List<AnnouncementModel>> getMyAnnouncements() async {
    try {
      final response = await _dio.get(
        '/announcements/my-announcements',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = response.data;
        return responseData
            .map((item) => AnnouncementModel.fromMap(item))
            .toList();
      } else {
        AppLogger.e(
            'Failed to get my announcements. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to get my announcements. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during get my announcements: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during get my announcements: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  /// Gets all the announcements created by a user from the server.
  ///
  /// [token] is the JSON Web Token used to authenticate the request.
  ///
  /// [id] is the ID of the user whose announcements to retrieve.
  ///
  /// Returns a list of [AnnouncementModel] representing all announcements
  /// created by the user.
  ///
  /// Throws an [AppException] if a network error or unexpected error occurs.
  Future<List<AnnouncementModel>> getAnnouncementsByUser(
    String id) async {
    try {
      final response = await _dio.get(
        '/announcements/users/$id',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = response.data;
        return responseData
            .map((item) => AnnouncementModel.fromMap(item))
            .toList();
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

    /// Gets an announcement by ID from the server.
  ///
  /// [token] is the JSON Web Token used to authenticate the request.
  ///
  /// [id] is the ID of the announcement to retrieve.
  ///
  /// Returns an [AnnouncementModel] representing the requested announcement.
  ///
  /// Throws an [AppException] if a network error or unexpected error occurs.
  Future<AnnouncementModel> getAnnouncementByID(String id) async {
    try {
      final response = await _dio.get(
        '/announcements/$id',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AnnouncementModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to get my announcements. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to get my announcements. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during get my announcements: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during get my announcements: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  /// Gets all the announcements created by a user from the server, filtered by
  /// their creation date.
  ///
  /// [token] is the JSON Web Token used to authenticate the request.
  ///
  /// [startDate] is the start date of the range of creation dates to retrieve
  /// announcements from.
  ///
  /// [endDate] is the end date of the range of creation dates to retrieve
  /// announcements from.
  ///
  /// Returns a list of [AnnouncementModel] representing all announcements
  /// created by the user in the given range.
  ///
  /// Throws an [AppException] if a network error or unexpected error occurs.
  Future<List<AnnouncementModel>> getMyAnnouncementsByCreationDate(String startDate, String endDate) async {
    try {
      final response = await _dio.get(
        '/announcements/my-announcements/creation-range',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
        },
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Se asume que response.data es una lista de mapas (JSON)
        List<dynamic> data = response.data;
        List<AnnouncementModel> announcements = data
            .map((json) =>
                AnnouncementModel.fromMap(json as Map<String, dynamic>))
            .toList();
        return announcements;
        /* final List<dynamic> responseData = response.data;
        return responseData
          .map((item) => AnnouncementModel.fromMap(item))
          .toList(); */
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

  /// Gets all the announcements created by a user from the server, filtered by
  /// their publication date.
  ///
  /// [token] is the JSON Web Token used to authenticate the request.
  ///
  /// [startDate] is the start date of the range of creation dates to retrieve
  /// announcements from.
  ///
  /// [endDate] is the end date of the range of creation dates to retrieve
  /// announcements from.
  ///
  /// Returns a list of [AnnouncementModel] representing all announcements
  /// created by the user in the given range.
  ///
  /// Throws an [AppException] if a network error or unexpected error occurs.
  Future<List<AnnouncementModel>> getMyAnnouncementsByPublicationDate(String startDate, String endDate) async {
    try {
      final response = await _dio.get(
        '/announcements/my-announcements/publication-range',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
        },
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Se asume que response.data es una lista de mapas (JSON)
        List<dynamic> data = response.data;
        List<AnnouncementModel> announcements = data
            .map((json) =>
                AnnouncementModel.fromMap(json as Map<String, dynamic>))
            .toList();
        return announcements;
        /* final List<dynamic> responseData = response.data;
        return responseData
          .map((item) => AnnouncementModel.fromMap(item))
          .toList(); */
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

    Future<List<AnnouncementModel>> getAnnouncementsByCreationDate(String startDate, String endDate) async {
    try {
      final response = await _dio.get(
        '/announcements/creation-range',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
        },
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Se asume que response.data es una lista de mapas (JSON)
        List<dynamic> data = response.data;
        List<AnnouncementModel> announcements = data
            .map((json) =>
                AnnouncementModel.fromMap(json as Map<String, dynamic>))
            .toList();
        return announcements;
        /* final List<dynamic> responseData = response.data;
        return responseData
          .map((item) => AnnouncementModel.fromMap(item))
          .toList(); */
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

    Future<List<AnnouncementModel>> getAnnouncementsByPublishDate(String startDate, String endDate) async {
    try {
      final response = await _dio.get(
        '/announcements/publication-range',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
        },
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Se asume que response.data es una lista de mapas (JSON)
        List<dynamic> data = response.data;
        List<AnnouncementModel> announcements = data
            .map((json) =>
                AnnouncementModel.fromMap(json as Map<String, dynamic>))
            .toList();
        return announcements;
        /* final List<dynamic> responseData = response.data;
        return responseData
          .map((item) => AnnouncementModel.fromMap(item))
          .toList(); */
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

  /// Creates a new announcement on the server.
  ///
  /// [request] is the [CreateAnnouncementRequest] containing the announcement details.
  /// [token] is the JSON Web Token used to authenticate the request.
  ///
  /// Returns an [AnnouncementModel] representing the created announcement.
  ///
  /// Throws an [AppException] if a network error or unexpected error occurs.

  Future<AnnouncementModel> createAnnouncement(
      CreateAnnouncementRequest request) async {
    try {
      final response = await _dio.post(
        '/announcements',
        data: request.toJson(),
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AnnouncementModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to create announcements. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to create announcements. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during create announcements: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during create announcements: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  /// Updates an announcement on the server.
  ///
  /// [request] is the [UpdateAnnouncementRequest] containing the announcement details.
  /// [token] is the JSON Web Token used to authenticate the request.
  ///
  /// Returns an [AnnouncementModel] representing the updated announcement.
  ///
  /// Throws an [AppException] if a network error or unexpected error occurs.
  Future<AnnouncementModel> updateAnnouncement(
      UpdateAnnouncementRequest request) async {
    try {
      final response = await _dio.patch(
        '/announcements/${request.id}',
        data: request.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.i('Update Response - Status: ${response.statusCode}');
        return AnnouncementModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to update announcements. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to update announcements. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during update announcements: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during update announcements: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  /// Publishes an announcement on the server.
  ///
  /// [token] is the JSON Web Token used to authenticate the request.
  /// [id] is the ID of the announcement to publish.
  ///
  /// Returns an [AnnouncementModel] representing the published announcement.
  ///
  /// Throws an [AppException] if a network error or unexpected error occurs.
  Future<AnnouncementModel> publishAnnouncement(String id) async {
    try {
      final response = await _dio.patch(
        '/announcements/$id/publish',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.i('Publish Response - Status: ${response.statusCode}');
        return AnnouncementModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to publish announcements. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to publish announcements. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during publish announcements: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during publish announcements: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  /// Deletes an announcement from the server.
  ///
  /// [id] is the ID of the announcement to delete.
  /// [token] is the JSON Web Token used to authenticate the request.
  ///
  /// Throws an [AppException] if a network error or unexpected error occurs.
  /// Logs the success or failure of the delete operation.

  Future<AnnouncementModel> deleteAnnouncement(String id) async {
    try {
      final response = await _dio.delete(
        '/announcements/$id',
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLogger.i(
            'Announcement deleted successfully. Status: ${response.statusCode}');
        return AnnouncementModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to delete announcement. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to delete announcement. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during delete announcement: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during delete announcement: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }
}
