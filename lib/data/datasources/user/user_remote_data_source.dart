import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/models/user/user_model.dart';
import 'package:esvilla_app/data/models/user/user_update_dto.dart';

class UserRemoteDataSource{
  final Dio dio;

  UserRemoteDataSource(this.dio);

  Future<UserModel> myProfile(String token) async {
    try {
      final response = await dio.get(
        '/users/profile',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          }
        ),
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        AppLogger.e(
            'Failed to login. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to login. Status: ${response.statusCode}, Body: ${response.data}');
      }
    }on DioException catch (e) {
      AppLogger.e('Dio error during get the user info: $e');
      throw AppException.fromDioExceptionType(e.type);
    }catch (e) {
      AppLogger.e('Unexpected error during login: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }  
}

  Future<UserModel> updateMyInfo(UserUpdateDto dto, String token) async {
    try {
      final response = await dio.put(
        '/users/profile',
        data: dto.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }
        ),
      );
      AppLogger.i('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        AppLogger.e(
            'Failed to update the user info. Status: ${response.statusCode}, Body: ${response.data}');

        throw Exception(
            'Failed to update the user info. Status: ${response.statusCode}, Body: ${response.data}');
      }
    }on DioException catch (e) {
      AppLogger.e('Dio error during update the user info: $e');
      throw AppException.fromDioExceptionType(e.type);
    }catch (e) {
      AppLogger.e('Unexpected error during update the user info: $e');
      throw AppException(code: -1, message: 'Unexpected error occurred');
    }  
}


}