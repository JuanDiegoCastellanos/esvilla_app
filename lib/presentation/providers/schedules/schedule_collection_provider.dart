import 'package:esvilla_app/presentation/providers/schedules/schedule_model_presentation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/* 
class ScheduleRecollection {
  final List<DaySchedule> scheduleDays;
  ScheduleRecollection(this.scheduleDays);
}

class DaySchedule {
  final int id;
  final String name;
  final List<TimeBySector> timeBySectors;
  DaySchedule({required this.id, required this.name}) : timeBySectors = [];
}

class TimeBySector {
  final String starthour, endHour;
  final List<Sector> sectors;
  TimeBySector({required this.starthour, required this.endHour, required this.sectors});
}

class Sector { final String name; Sector(this.name); }

class ScheduleRecollectionNotifier extends StateNotifier<ScheduleRecollection> {
  ScheduleRecollectionNotifier() 
    : super(ScheduleRecollection(List.generate(7, (i) => DaySchedule(id: i+1, name: _dayName(i+1)))));

  void rebuild(List<ScheduleModelPresentation> schedules) {
    // limpias
    for (var d in state.scheduleDays) {
      d.timeBySectors.clear();
    }

    for (var s in schedules) {
      for (var day in s.days ?? []) {
        final d = state.scheduleDays.firstWhere((w) => w.name.toLowerCase() == day.toLowerCase());
        d.timeBySectors.add(TimeBySector(
          starthour: s.startTime ?? '',
          endHour:  s.endTime ?? '',
          sectors:   s.associatedSectors?.map((n) => Sector(n)).toList() ?? [],
        ));
      }
    }
    // forzamos notificación
    state = ScheduleRecollection([...state.scheduleDays]);
  }

  static String _dayName(int id) {
    switch (id) {
      case 1: return 'Lunes';
      case 2: return 'Martes';
      case 3: return 'Miércoles';
      case 4: return 'Jueves';
      case 5: return 'Viernes';
      case 6: return 'Sábado';
      case 7: return 'Domingo';
      default: return '';
    }
  }
}

final scheduleRecollectionProvider =
  StateNotifierProvider<ScheduleRecollectionNotifier, ScheduleRecollection>(
    (_) => ScheduleRecollectionNotifier());
 */