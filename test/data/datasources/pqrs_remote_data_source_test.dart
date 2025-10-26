import 'package:dio/dio.dart';
import 'package:esvilla_app/data/datasources/pqrs/pqrs_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late PqrsRemoteDataSource ds;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
    adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;
    ds = PqrsRemoteDataSource(dio);
  });

  test('getPqrs retorna una lista parseada', () async {
    final now = DateTime.now().toIso8601String();
    final item = {
      '_id': 'p1',
      'asunto': 'A',
      'descripcion': 'D',
      'idRadicador': 'u1',
      'nombreRadicador': 'Juan',
      'telefonoRadicador': '300',
      'emailRadicador': 'a@b.com',
      'documentoRadicador': 'CC',
      'estado': 'pendiente',
      'createdAt': now,
      'updatedAt': now,
    };
    adapter.onGet('/pqrs', (server) => server.reply(200, [item]));

    final list = await ds.getPqrs();
    expect(list.length, 1);
    expect(list.first.id, 'p1');
  });

  test('getPqrsById retorna un modelo', () async {
    final now = DateTime.now().toIso8601String();
    final item = {
      '_id': 'p1',
      'asunto': 'A',
      'descripcion': 'D',
      'idRadicador': 'u1',
      'nombreRadicador': 'Juan',
      'telefonoRadicador': '300',
      'emailRadicador': 'a@b.com',
      'documentoRadicador': 'CC',
      'estado': 'pendiente',
      'createdAt': now,
      'updatedAt': now,
    };
    adapter.onGet('/pqrs/p1', (server) => server.reply(200, item));

    final model = await ds.getPqrsById('p1');
    expect(model.id, 'p1');
    expect(model.subject, 'A');
  });
}
