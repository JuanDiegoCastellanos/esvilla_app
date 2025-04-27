import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/models/users/create_user_request.dart';
import 'package:esvilla_app/data/models/users/update_password_request.dart';
import 'package:esvilla_app/data/models/users/user_model.dart';
import 'package:esvilla_app/data/models/users/user_update_request.dart';

class UsersRemoteDataSource {
  final Dio _dio;

  UsersRemoteDataSource(this._dio);

  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _dio.get('/users/list');
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = response.data;
        return responseData.map((item) => UserModel.fromMap(item)).toList();
      } else {
        AppLogger.e(
            'Failed to get users. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to get users. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during get users: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during get users: ${e.toString()}');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      final response = await _dio.get(
        '/users/$id',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to get user by Id . Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to get user by Id. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during get user by Id: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during get user by Id: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<UserModel> createUser(CreateUserRequest model) async {
    try {
      final response = await _dio.post(
        '/users/',
        data: model.toMap()
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to create user. Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to create user. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during create users: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during create user: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<UserModel> updateUser(UpdateUserRequest model) async {
    try {
      final response = await _dio.put(
        '/users/${model.id}',
        data: model.toJson()
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to update user by Id . Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to update user by Id. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during update user by Id: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during update user by Id: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<UserModel> deleteUser(String id) async {
    try {
      final response = await _dio.delete(
        '/users/$id',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to delete user by Id . Status: ${response.statusCode}, Body: ${response.data}');
        throw Exception(
            'Failed to delete user by Id. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during delete user by Id: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during delete user by Id: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<UserModel> myProfile() async {
    try {
      final response = await _dio.get(
        '/users/profile',
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to login. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to login. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during get the user info: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during login: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }

  Future<UserModel> updateMyInfo(UpdateUserRequest model) async {
    try {
      final response = await _dio.patch(
        '/users/profile',
        data: model.toJson()
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to update the user info. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to update the user info. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during update the user info: ${e.response?.data}');
      throw AppException(code:409, message: e.response?.data['message']['message']);
    } catch (e) {
      //AppLogger.e('Unexpected error during update the user info: $e');
      throw AppException(code: -1, message: '$e');
    }
  }

  Future<UserModel> updateMyPassword(UpdatePasswordRequest model) async {
    try {
      final response = await _dio.patch(
        'users/profile/password',
        data: model.toJson()
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromMap(response.data);
      } else {
        AppLogger.e(
            'Failed to update the user info. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to update the user info. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.e('Dio error during update the user info: $e');
      throw AppException.fromDioExceptionType(e.type);
    } catch (e) {
      AppLogger.e('Unexpected error during update the user info: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }
  }
}
