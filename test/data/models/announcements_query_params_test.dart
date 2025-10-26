import 'package:esvilla_app/data/models/announcements/announcements_query_params.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toMap incluye sólo campos no nulos y formatea fechas ISO', () {
    final start = DateTime(2024, 1, 2, 3, 4, 5);
    final end = DateTime(2024, 2, 3, 4, 5, 6);
    final params = AnnouncementsQueryParams(
      page: 2,
      limit: 10,
      sortBy: 'createdAt',
      sortOrder: 'desc',
      startDate: start,
      endDate: end,
    );
    final map = params.toMap();
    expect(map['page'], 2);
    expect(map['limit'], 10);
    expect(map['sortBy'], 'createdAt');
    expect(map['sortOrder'], 'desc');
    expect(map['startDate'], start.toIso8601String());
    expect(map['endDate'], end.toIso8601String());
    // Ningún campo inesperado
    expect(map.containsKey('unknown'), isFalse);
  });
}


