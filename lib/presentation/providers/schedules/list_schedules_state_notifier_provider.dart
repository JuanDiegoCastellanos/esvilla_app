import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/presentation/providers/schedules/get_all_schedules_use_case_provider.dart';
import 'package:esvilla_app/presentation/providers/schedules/schedule_model_presentation.dart';
import 'package:esvilla_app/presentation/providers/sectors/get_sectors_by_id_use_case_provider.dart';
import 'package:esvilla_app/presentation/widgets/home/user/trash_recollection_schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// se me ocurre ue pueda cambiar el tipo de modelo ya que se require otro tipo,
// usar una tecnica para nombre el sector ponerle rural: o centro: para que se reconozca 
// y asi poder reclasificarlo y poner no se un chip de color verde si es rural, naranja del centro y los demas morado 
// es la solucion temporal y ya no mas
final listSchedulesProvider = FutureProvider.autoDispose<List<ScheduleModelPresentation>>(
  (ref) async {
    try {
      final schedulesList = await ref.read(getAllSchedulesUseCaseProvider).call();
      final getSectorsByIdUseCase = ref.read(getSectorsByIdUseCaseProvider);
      final results = <ScheduleModelPresentation>[];
      
      for (final schedule in schedulesList) {
        final sectors = <String>[];
        for(var sector in schedule.associatedSectors){
          final sectorEntity = await getSectorsByIdUseCase.call(sector);
          sectors.add(sectorEntity.name);
        }
        results.add(ScheduleModelPresentation(
          id: schedule.id,
          active: schedule.active,
          createdAt: schedule.createdAt,
          days: schedule.days,
          endTime: schedule.endTime,
          garbageType: schedule.garbageType,
          observations: schedule.observations,
          startTime: schedule.startTime,
          updatedAt: schedule.updatedAt,
          associatedSectors: sectors,
        ));
      }
      //AppLogger.f("Schedules loaded: ${results.length}");
      // Construir la recollection aquí para actualizar el UI
      _updateScheduleRecollection(ref, results);
      
      return results;

    } catch (e,t) {
      AppLogger.e("Error loading schedules: $e, $t");
      rethrow;
    }
  }
);

// Función auxiliar para actualizar el estado de scheduleRecollectionProvider
void _updateScheduleRecollection(Ref ref, List<ScheduleModelPresentation> schedules) {
  // Crear una nueva ScheduleRecollection con días limpios
  final newRecollection = ScheduleRecollection(
    scheduleDays: <DaySchedule>[
      DaySchedule(id: 1, name: 'Lunes', timeBySectors: []),
      DaySchedule(id: 2, name: 'Martes', timeBySectors: []),
      DaySchedule(id: 3, name: 'Miércoles', timeBySectors: []),
      DaySchedule(id: 4, name: 'Jueves', timeBySectors: []),
      DaySchedule(id: 5, name: 'Viernes', timeBySectors: []),
      DaySchedule(id: 6, name: 'Sábado', timeBySectors: []),
      DaySchedule(id: 7, name: 'Domingo', timeBySectors: []), 
    ]
  );
  
  // Rellenar con los datos de los horarios
  for (var schedule in schedules) {
    if (schedule.days == null) continue;
    
    for (var dayName in schedule.days!) {
      final day = newRecollection.scheduleDays.firstWhere(
        (d) => d.name.toLowerCase() == dayName.toLowerCase(),
        orElse: () => throw Exception('Day not found: $dayName'),
      );
      
      day.timeBySectors.add(
        TimeBySector(
          starthour: schedule.startTime ?? '',
          endHour: schedule.endTime ?? '',
          sectors: schedule.associatedSectors?.map(
            (sector) => Sector(name: sector)
          ).toList() ?? [],
        )
      );
    }
  }
  ref.read(scheduleRecollectionProvider.notifier).state = newRecollection;
}

