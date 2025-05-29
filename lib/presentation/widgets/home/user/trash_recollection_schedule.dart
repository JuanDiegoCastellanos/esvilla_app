
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DaySchedule {
  final int id;
  final String name;
  List<TimeBySector> timeBySectors;
  DaySchedule({
    required this.id,
    required this.name,
    required this.timeBySectors,
  });
}

class TimeBySector {
  final String starthour;
  final String endHour;
  List<Sector> sectors;
  TimeBySector({
    required this.starthour,
    required this.endHour,
    required this.sectors,
  });
}

class Sector {
  final String name;
  Sector({
    required this.name,
  });
}

class ScheduleRecollection {
  final List<DaySchedule> scheduleDays;
  ScheduleRecollection({required this.scheduleDays});
}

final scheduleRecollectionProvider = StateProvider<ScheduleRecollection>((ref) {
  return ScheduleRecollection(scheduleDays: <DaySchedule>[
    DaySchedule(id: 1, name: 'Lunes', timeBySectors: []),
    DaySchedule(id: 2, name: 'Martes', timeBySectors: []),
    DaySchedule(id: 3, name: 'Miércoles', timeBySectors: []),
    DaySchedule(id: 4, name: 'Jueves', timeBySectors: []),
    DaySchedule(id: 5, name: 'Viernes', timeBySectors: []),
    DaySchedule(id: 6, name: 'Sábado', timeBySectors: []),
    DaySchedule(id: 7, name: 'Domingo', timeBySectors: []),
  ]);
});
