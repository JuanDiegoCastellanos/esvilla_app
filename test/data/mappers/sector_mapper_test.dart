import 'package:esvilla_app/data/mappers/sector/sector_mapper.dart';
import 'package:esvilla_app/data/models/sectors/location_model.dart';
import 'package:esvilla_app/data/models/sectors/sector_model.dart';
import 'package:esvilla_app/domain/entities/sectors/location_entity.dart';
import 'package:esvilla_app/domain/entities/sectors/sector_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SectorMapper toEntity/toModel y requests', () {
    final now = DateTime.now();
    final model = SectorModel(
      id: 'sec1', name: 'Centro', description: 'desc',
      location: LocationModel(type: 'Polygon', coordinates: const [[[0.0, 0.0]]]),
      createdAt: now, updatedAt: now,
    );

    final e = SectorMapper.toEntity(model);
    expect(e.id, 'sec1');
    expect(e.location, isA<LocationEntity>());

    final back = SectorMapper.toModel(e);
    expect(back.name, 'Centro');
  });
}


