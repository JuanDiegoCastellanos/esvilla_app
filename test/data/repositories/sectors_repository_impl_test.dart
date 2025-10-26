import 'package:esvilla_app/data/datasources/sectors/sectors_remote_data_source.dart';
import 'package:esvilla_app/data/models/sectors/location_model.dart';
import 'package:esvilla_app/data/models/sectors/sector_model.dart';
import 'package:esvilla_app/data/repositories/sectors/sector_repository_impl.dart';
import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSectorsDs extends Mock implements SectorsRemoteDataSource {}

void main() {
  late _MockSectorsDs ds;
  late SectorRepositoryImpl repo;

  setUp(() {
    ds = _MockSectorsDs();
    repo = SectorRepositoryImpl(ds);
  });

  test('getAll mapea SectorModel a SectorEntity', () async {
    final now = DateTime.now();
    final model = SectorModel(
      id: 'sec1',
      name: 'Centro',
      description: 'desc',
      location: LocationModel(type: 'Polygon', coordinates: const [
        [
          [0.0, 0.0],
          [1.0, 0.0],
          [1.0, 1.0]
        ]
      ]),
      createdAt: now,
      updatedAt: now,
    );
    when(() => ds.getSectors()).thenAnswer((_) async => [model]);

    final list = await repo.getAll();
    expect(list, isA<List<SectorEntity>>());
    expect(list.first.id, 'sec1');
    expect(list.first.name, 'Centro');
  });
}
