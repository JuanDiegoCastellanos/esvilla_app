import 'package:esvilla_app/data/models/announcements/announcements_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnnouncementModel', () {
    test('fromMap y toJson conservan campos clave', () {
      final now = DateTime.now();
      final json = {
        "_id": "a1",
        "title": "T",
        "description": "D",
        "mainImage": "mi",
        "body": "b",
        "secondaryImage": "si",
        "publicationDate": now.toIso8601String(),
        "createdBy": "u1",
        "createdAt": now.toIso8601String(),
        "updatedAt": now.toIso8601String(),
      };
      final model = AnnouncementModel.fromMap(json);
      expect(model.id, 'a1');
      expect(model.title, 'T');
      final back = model.toJson();
      expect(back['_id'], 'a1');
      expect(back['title'], 'T');
      expect(back['publicationDate'], isNotNull);
    });
  });
}
