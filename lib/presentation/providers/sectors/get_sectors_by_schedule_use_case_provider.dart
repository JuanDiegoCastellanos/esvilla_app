
import 'package:esvilla_app/domain/use_cases/schedules/get_sectors_by_schedule_use_case.dart';
import 'package:esvilla_app/presentation/providers/schedules/schedules_reposiroty_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getSectorsByScheduleUseCaseProvider = Provider<GetSectorsByScheduleUseCase>((ref) {
  final repo = ref.watch(schedulesRepositoryProvider);
  return GetSectorsByScheduleUseCase(repo);
});
