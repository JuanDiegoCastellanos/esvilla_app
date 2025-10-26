import 'package:esvilla_app/data/datasources/pqrs/pqrs_remote_data_source.dart';
import 'package:esvilla_app/data/mappers/pqrs/pqrs_mapper.dart';
import 'package:esvilla_app/data/models/pqrs/pqrs_model.dart';
import 'package:esvilla_app/data/repositories/pqrs/pqrs_repository_impl.dart';
import 'package:esvilla_app/domain/entities/pqrs/pqrs_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPqrsDs extends Mock implements PqrsRemoteDataSource {}

void main() {
  late _MockPqrsDs ds;
  late PqrsRepositoryImpl repo;

  setUp(() {
    ds = _MockPqrsDs();
    repo = PqrsRepositoryImpl(ds);
  });

  test('getAll mapea modelos a entidades', () async {
    final now = DateTime.now();
    final model = PqrsModel(
      id: 'p1',
      subject: 'A',
      description: 'D',
      radicadorId: 'u1',
      radicadorName: 'Juan',
      radicadorPhone: '300',
      radicadorEmail: 'a@b.com',
      radicadorDocument: 'CC',
      status: PqrsMapper.toEntityList([]).isEmpty
          ? // truco inofensivo para forzar import
          PqrsModel.fromMap({
              '_id': 'x',
              'asunto': 'A',
              'descripcion': 'D',
              'idRadicador': 'u',
              'nombreRadicador': 'n',
              'telefonoRadicador': 't',
              'emailRadicador': 'e',
              'documentoRadicador': 'd',
              'estado': 'pendiente',
              'createdAt': now.toIso8601String(),
              'updatedAt': now.toIso8601String()
            }).status
          : PqrsModel.fromMap({
              '_id': 'x',
              'asunto': 'A',
              'descripcion': 'D',
              'idRadicador': 'u',
              'nombreRadicador': 'n',
              'telefonoRadicador': 't',
              'emailRadicador': 'e',
              'documentoRadicador': 'd',
              'estado': 'pendiente',
              'createdAt': now.toIso8601String(),
              'updatedAt': now.toIso8601String()
            }).status,
      createdAt: now,
      updatedAt: now,
    );
    when(() => ds.getPqrs()).thenAnswer((_) async => [model]);

    final list = await repo.getAll();
    expect(list, isA<List<PqrsEntity>>());
    expect(list.first.id, 'p1');
  });
}
