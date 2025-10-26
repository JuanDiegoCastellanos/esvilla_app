import 'package:esvilla_app/data/mappers/announcements/announcements_mapper.dart';
import 'package:esvilla_app/data/models/announcements/announcements_model.dart';
import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AnnouncementsMapper toEntity/toModel and lists', () {
    final now = DateTime.now();
    final model = AnnouncementModel(
      id: 'a1', title: 't', description: 'd', mainImage: 'm', body: 'b', secondaryImage: 's',
      publicationDate: now, createdBy: 'u1', createdAt: now, updatedAt: now,
    );
    final entity = AnnouncementsMapper.toEntity(model);
    expect(entity.id, 'a1');
    expect(entity.title, 't');

    final back = AnnouncementsMapper.toModel(entity);
    expect(back.id, 'a1');
    expect(back.description, 'd');

    final listE = AnnouncementsMapper.toEntityList([model]);
    expect(listE, isA<List<AnnouncementsEntity>>());
    final listM = AnnouncementsMapper.toModelList(listE);
    expect(listM.first.id, 'a1');
  });
}


