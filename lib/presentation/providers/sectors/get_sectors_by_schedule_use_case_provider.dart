
import 'package:esvilla_app/domain/use_cases/schedules/get_sectors_by_schedule_use_case.dart';
import 'package:esvilla_app/presentation/providers/schedules/schedules_reposiroty_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* final getSectorByScheduleUseCaseProvider = Provider.family<Future<List<String>>, String>((ref, scheduleId) async {
  final repo = ref.watch(schedulesRepositoryProvider);
  
  final sectorsList = await repo.getSectorsByScheduleId(scheduleId);
  return GetSectorsByScheduleUseCase(repo);
}); */

final getSectorsByScheduleUseCaseProvider = Provider<GetSectorsByScheduleUseCase>((ref) {
  final repo = ref.watch(schedulesRepositoryProvider);
  return GetSectorsByScheduleUseCase(repo);
});
