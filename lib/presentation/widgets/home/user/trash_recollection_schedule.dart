import 'package:esvilla_app/presentation/providers/schedules/schedule_screen_model.dart';
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

  List<DaySchedule> buildScheduleRecollectionForScreen(
      List<ScheduleScreenModel> schedulesModel) {
    // Limpiar timeBySectors existentes antes de reconstruir
    for (var day in scheduleDays) {
      day.timeBySectors.clear();
    }
    for (var schedule in schedulesModel) {
      if (schedule.days == null || schedule.days!.isEmpty) continue;
      // Para cada día en el horario
      for (var day in schedule.days!) {
        // Encontrar el día correspondiente en scheduleDays
        for (var scheduleDay in scheduleDays) {
          if (scheduleDay.name.toLowerCase() == day.toLowerCase()) {
            // Añadir el horario a ese día
            scheduleDay.timeBySectors.add(TimeBySector(
              starthour: schedule.startTime ?? '',
              endHour: schedule.endTime ?? '',
              sectors: schedule.associatedSectors
                      ?.map((sector) => Sector(name: sector))
                      .toList() ??
                  [],
            ));
            break; // Ya encontramos el día, no necesitamos seguir buscando
          }
        }
      }
    }
    return scheduleDays;
  }
}

final scheduleRecollectionProvider = StateProvider<ScheduleRecollection>((ref) {
  return ScheduleRecollection(scheduleDays: <DaySchedule>[
    DaySchedule(id: 1, name: 'Lunes', timeBySectors: []),
    DaySchedule(id: 2, name: 'Martes', timeBySectors: []),
    DaySchedule(id: 3, name: 'Miercoles', timeBySectors: []),
    DaySchedule(id: 4, name: 'Jueves', timeBySectors: []),
    DaySchedule(id: 5, name: 'Viernes', timeBySectors: []),
    DaySchedule(id: 6, name: 'Sabado', timeBySectors: []),
    DaySchedule(id: 7, name: 'Domingo', timeBySectors: []),
  ]);
});
