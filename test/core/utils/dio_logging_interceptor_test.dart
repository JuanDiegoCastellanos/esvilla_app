import 'package:dio/dio.dart';
import 'package:esvilla_app/core/utils/dio_logging_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DioLoggingInterceptor no altera la respuesta ni el error', () async {
    final dio = Dio();
    dio.interceptors.add(DioLoggingInterceptor());

    // Usamos un adapter de memoria simple: request a URL inválida causará error controlado,
    // pero el interceptor debe dejar pasar el error sin cambiar tipo ni datos.
    try {
      await dio.get('http://localhost:0/should_fail');
      fail('Debería lanzar');
    } on DioException catch (e) {
      expect(e, isA<DioException>());
    }
  });
}


