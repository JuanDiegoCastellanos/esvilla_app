import 'package:dio/dio.dart';
import 'package:esvilla_app/data/models/auth_response.dart';
class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<AuthResponse> login(String email, String password) async {
   
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'identifier': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {   

        return AuthResponse.fromJson(response.data);

      } else {
        throw Exception(
            'Failed to login. Status: ${response.statusCode}, Body: ${response.data}');
      }
    } on DioException catch (e) {
      print('Dio error during login: $e');
      throw Exception('Network or server error: ${e.message}');
    } catch (e) {
      print('Unexpected error during login: $e');
      throw Exception('Unexpected error occurred');
    }
  }
}
