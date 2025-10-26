import 'package:dio/dio.dart';
import 'package:esvilla_app/data/datasources/schedules/schedules_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SchedulesRemoteDataSource ds;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
    adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;
    ds = SchedulesRemoteDataSource(dio);
  });

  test('getSchedules retorna lista parseada', () async {
    final now = DateTime.now().toIso8601String();
    final item = {
      '_id': 's1',
      'dias': ['Lunes', 'Martes'],
      'horaInicio': '08:00',
      'horaFin': '10:00',
      'sectoresAsociados': ['z1', 'z2'],
      'activo': true,
      'observaciones': 'obs',
      'tipoBasura': 'organica',
      'createdAt': now,
      'updatedAt': now,
    };
    adapter.onGet('/schedules', (server) => server.reply(200, [item]));

    final list = await ds.getSchedules();
    expect(list.length, 1);
    expect(list.first.id, 's1');
    expect(list.first.days, contains('Lunes'));
  });

  test('getSectorsByScheduleID retorna lista de sectores', () async {
    adapter.onGet(
        '/schedules/s1/sectors', (server) => server.reply(200, ['a', 'b']));
    final sect = await ds.getSectorsByScheduleID('s1');
    expect(sect, ['a', 'b']);
  });
}
